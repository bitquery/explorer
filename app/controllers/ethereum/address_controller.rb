module Ethereum
  class AddressController < NetworkController
    layout 'tabs'

    before_action :query_graphql, :redirect_by_type

    REALTIME_QUERY = <<-GRAPHQL.freeze
      query ($network: evm_network, $address: String!) {
        EVM(dataset: realtime, network: $network) {
          calls: Calls(where: {Call: {To: {is: $address}}}, limit: {count: 1}) {
            Block { Time }
          }
          token: Transfers(
            where: {Transfer: {Currency: {SmartContract: {is: $address}}}}
            limit: {count: 1}
          ) {
            Transfer {
              Currency { Symbol Name Fungible Native }
            }
          }
        }
      }
    GRAPHQL

    ARCHIVE_QUERY = REALTIME_QUERY.sub('dataset: realtime', 'dataset: archive')

    private

    def load_evm_data
      cache_key = ["ethereum", "evm_data", @network[:streaming], @address]

      if Rails.cache.exist?(cache_key)
        Rails.logger.info("[AddressController] cache HIT for #{cache_key.inspect}")
      else
        Rails.logger.info("[AddressController] cache MISS for #{cache_key.inspect}")
      end

      Rails.cache.fetch(cache_key, expires_in: 1.day) do
        Rails.logger.info("[AddressController] fetching EVM data for #{cache_key.inspect}")
        data = fetch_evm(REALTIME_QUERY)
        if data.calls.empty? && data.token.empty?
          data = fetch_evm(ARCHIVE_QUERY)
        end
        data
      end
    end

    def query_graphql
      @address = params[:address]
      return unless @address.start_with?('0x')

      evm_data = load_evm_data

      if evm_data.token.any?
        @info        = evm_data.token.first.Transfer
        @check_token = 'token'
        @fungible    = @info.Currency.Fungible
      elsif evm_data.calls.any?
        @info       = evm_data.calls.first.Block
        @check_call = 'calls'
      end
    end

    def fetch_evm(query)
      Graphql::V2
        .query_with_retry(
          query,
          variables: { network: @network[:streaming], address: @address },
          context:   { authorization: @streaming_access_token },
          use_eap:   @network[:use_eap]
        )
        .data.EVM
    end

    def redirect_by_type
      if @check_token == 'token'
        if @fungible
          redirect_to controller: 'ethereum/token', action: 'nft_smart_contract'
        else
          change_controller! 'ethereum/token'
        end
      elsif @check_call == 'calls'
        change_controller! 'ethereum/smart_contract'
      end
    end
  end
end
