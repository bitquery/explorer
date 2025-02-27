module Ethereum
  class AddressController < NetworkController
    layout 'tabs'

    before_action :query_graphql, :redirect_by_type

    QUERY = <<-GRAPHQL.freeze
          query ($network: evm_network, $address: String!) {
        EVM(dataset: archive, network: $network) {
          address: Transfers(
            where: {Transfer: {Sender: {is: $address}}}
            limit: {count: 1}
          ) {
            Transfer {
              Sender
              Receiver
              Currency {
                Symbol
                SmartContract
                Name
                Fungible
              }
            }
          }
          token: Transfers(
            where: {Transfer: {Currency: {SmartContract: {is: $address}}}}
            limit: {count: 1}
          ) {
            Transfer {
              Sender
              Receiver
              Currency {
                Symbol
                SmartContract
                Name
                Fungible
                Native
              }
            }
          }
          calls: Calls(
            where: {Call: {To: {is: $address}, Signature: {SignatureHash: {not: ""}}}}
            limit: {count: 1}
          ) {
            Call {
              Signature {
                SignatureHash
              }
            }
          }
        }
      }
    GRAPHQL

    private

    def query_graphql
      @address = params[:address]
      return unless @address.starts_with?('0x')
      result = Graphql::V2.query_with_retry(QUERY, variables: { network: @network[:streaming],  address: (@address == 'ETH' ? '0x' : @address) },
                                            context: { authorization: @streaming_access_token }, use_eap: @network[:use_eap]).data.EVM
      if result[:token].any?
        @info = result[:token].first[:Transfer]
        @check_token = 'token'
        @fungible = @info[:Currency][:Fungible] if @info[:Currency]
      elsif result[:calls].any?
        @info = result[:address].any? ? result[:address].first[:Transfer] : @address
        @check_call = 'calls'
      end
    end

    def redirect_by_type
      if @info.try(:Currency) || @address == @network[:currency]
        if @fungible == false
          redirect_to controller: 'ethereum/token', action: 'nft_smart_contract'
          return
        end
        change_controller! 'ethereum/token'
      elsif @check_call == 'calls'
        change_controller! 'ethereum/smart_contract'
      end
    end
  end
end
