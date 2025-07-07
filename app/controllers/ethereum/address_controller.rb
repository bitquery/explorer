require 'ostruct'

module Ethereum
  class AddressController < NetworkController
    layout 'tabs'

    before_action :query_graphql, :redirect_by_type

    REALTIME_QUERY = <<-GRAPHQL.freeze
      query ($network: evm_network, $address: String!) {
        EVM(dataset: realtime, network: $network) {
          token: Transfers(
            where: {Transfer: {Currency: {SmartContract: {is: $address}}}},
            limit: {count: 1}
          ) {
            Transfer {
              Currency { Symbol Name Fungible Native }
            }
          }
          events: Events(where: {Log: {SmartContract: {is: $address}}}, limit: {count: 1}) {
            count
          }
        }
      }
    GRAPHQL

    ARCHIVE_QUERY = REALTIME_QUERY.
      sub('dataset: realtime', 'dataset: archive')

    private

    def load_evm_data
      cache_key = ["ethereum", "evm_data", @network[:streaming], @address]

      Rails.cache.fetch(cache_key, expires_in: 1.day) do
        data = safe_fetch_evm(REALTIME_QUERY)

        if data.events.empty? && data.token.empty?
          data = safe_fetch_evm(ARCHIVE_QUERY)
        end

        data
      end
    end

    def safe_fetch_evm(query)
      fetch_evm(query)
    rescue JSON::ParserError, Net::ReadTimeout, StandardError => e
      BitqueryLogger.error("[AddressController] GraphQL fetch error: #{e.class}: #{e.message}")
      OpenStruct.new(
        events: [],
        token: []
      )
    end

    def fetch_evm(query)

      Graphql::V2
        .query_with_retry(
          query,
          variables: {
            network: @network[:streaming],
            address: @address
          },
          context:   { authorization: @streaming_access_token },
          use_eap:   @network[:use_eap]
        )
        .data.EVM
    end

    def query_graphql
      @address = params[:address]
      return unless @address.start_with?('0x')

      evm_data = load_evm_data

      if evm_data.token.any?
        @info        = evm_data.token.first.Transfer
        @check_token = 'token'
        @fungible    = @info.Currency.Fungible
      end
      
      if evm_data.events.any? && evm_data.events.first.count.to_i > 0
        @check_events = 'events'
      end
    end

    def redirect_by_type
      if @check_token == 'token'
        change_controller! 'ethereum/token'
      elsif @check_events == 'events'
        change_controller! 'ethereum/smart_contract'
      end
    end
    
    public
    
    def multichain
      @address = params[:address]
      
      cache_key = ["multichain_data", @address, @network[:network]].join(":")
      @multichain_data = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
        fetch_multichain_data_for_all_networks
      end
      
      @networks = {
        eth: { name: 'Ethereum', chain_id: '1', badge: 'ethereum-badge', icon: 'eth.svg' },
        bsc: { name: 'BSC', chain_id: '56', badge: 'bsc-badge', icon: 'bnb.svg' },
        arbitrum: { name: 'Arbitrum', chain_id: '42161', badge: 'arbitrum-badge', icon: 'currency/arbitrum.svg' },
        base: { name: 'Base', chain_id: '8453', badge: 'base-badge', icon: 'currency/base.svg' }
      }
      
      @network_stats = {}
      @networks.keys.each do |network|
        if @multichain_data[network]
          stats = @multichain_data[network][:stats] || {}
          received = if stats.respond_to?(:rec) && stats.rec.respond_to?(:first)
            stats.rec.first&.count.to_i
          elsif stats['rec'] && stats['rec'].first
            stats['rec'].first['count'].to_i
          else
            0
          end
          
          sent = if stats.respond_to?(:sent) && stats.sent.respond_to?(:first)
            stats.sent.first&.count.to_i
          elsif stats['sent'] && stats['sent'].first
            stats['sent'].first['count'].to_i
          else
            0
          end
          
          @network_stats[network] = {
            received: received,
            sent: sent,
            total: received + sent,
            top_currencies: process_top_currencies(@multichain_data[network][:currencies])
          }
        end
      end
      
      @recent_transfers = @multichain_data[:transfers] || []
    rescue => e
      Rails.logger.error "Failed to fetch multichain data: #{e.message}"
      @multichain_data = {}
      @network_stats = {}
      @recent_transfers = []
    end
    
    
    private
    
    def process_top_currencies(currencies_data)
      return [] unless currencies_data && currencies_data.Transfers
      
      currencies_data.Transfers.first(3).map do |item|
        {
          symbol: item.Transfer.Currency.Symbol || 'Unknown',
          name: item.Transfer.Currency.Name,
          count: item.total_sent.to_i
        }
      end
    rescue => e
      Rails.logger.error "Error processing currencies: #{e.message}"
      []
    end
    
    def fetch_multichain_data_for_all_networks
      networks = ['eth', 'bsc', 'arbitrum', 'base']
      data = {}
      
      require 'concurrent'
      
      network_promises = networks.map do |network|
        Concurrent::Promise.execute do
          [network, fetch_network_data(network)]
        end
      end
      
      transfers_promise = Concurrent::Promise.execute do
        fetch_all_network_transfers(networks)
      end
      
      network_results = network_promises.map(&:value!)
      network_results.each do |network, network_data|
        data[network.to_sym] = network_data
      end
      
      data[:transfers] = transfers_promise.value!
      data
    rescue => e
      Rails.logger.error "Failed to fetch multichain data: #{e.message}"
      { error: e.message }
    end
    
    def fetch_network_data(network)
      stats_query = <<-GRAPHQL
        query MyQuery($network: evm_network!, $address: String!) {
          EVM(network: $network, dataset: realtime) {
            rec: Transfers(where: {Transfer: {Receiver: {is: $address}}}) {
              count
            }
            sent: Transfers(where: {Transfer: {Sender: {is: $address}}}) {
              count
            }
          }
        }
      GRAPHQL
      
      currencies_query = <<-GRAPHQL
        query MyQuery($network: evm_network!, $address: String!) {
          EVM(network: $network, dataset: realtime) {
            Transfers(
              where: {Transfer: {Sender: {is: $address}}}
              limitBy: {by: Transfer_Currency_SmartContract}
              orderBy: {descendingByField: "total_sent"}
              limit: {count: 5}
            ) {
              total_sent: count
              Transfer {
                Currency {
                  Symbol
                  Name
                  Decimals
                }
              }
            }
          }
        }
      GRAPHQL
      
      stats_result = Graphql::V2.query_with_retry(
        stats_query,
        variables: { network: network, address: @address },
        context: { authorization: @streaming_access_token },
        use_eap: @network[:use_eap]
      )
      
      currencies_result = Graphql::V2.query_with_retry(
        currencies_query,
        variables: { network: network, address: @address },
        context: { authorization: @streaming_access_token },
        use_eap: @network[:use_eap]
      )
      
      {
        stats: stats_result.data.EVM,
        currencies: currencies_result.data.EVM
      }
    end
    
    def fetch_all_network_transfers(networks)
      transfers_query = <<-GRAPHQL
        query ($network: evm_network, $address: String!, $limit: Int!) {
          EVM(network: $network, dataset: realtime) {
            Transfers(
              limit: {count: $limit}
              orderBy: {descending: Block_Time}
              where: {any: [{Transfer: {Sender: {is: $address}}}, {Transfer: {Receiver: {is: $address}}}]}
            ) {
              ChainId
              Block {
                Number
                Time
              }
              Transfer {
                Receiver
                Sender
                Amount
                Success
                Currency {
                  SmartContract
                  Symbol
                }
              }
              Transaction {
                Hash
              }
            }
          }
        }
      GRAPHQL
      
      require 'concurrent'
      
      transfer_promises = networks.map do |network|
        Concurrent::Promise.execute do
          begin
            result = Graphql::V2.query_with_retry(
              transfers_query,
              variables: { network: network, address: @address, limit: 25 },
              context: { authorization: @streaming_access_token },
              use_eap: @network[:use_eap]
            )
            
            transfers = result.data.EVM.Transfers || []
            transfers.each { |t| t['network'] = network }
            transfers
          rescue => e
            Rails.logger.error "Failed to fetch transfers for #{network}: #{e.message}"
            []
          end
        end
      end
      
      all_transfers = transfer_promises.flat_map(&:value!)
      
      all_transfers.sort_by { |t| t.Block.Time }.reverse.first(50)
    end
    
  end
end
