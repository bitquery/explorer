class EthereumStreaming::AddressController < NetworkController
  layout 'tabs'

  before_action :query_graphql, :redirect_by_type

  # QUERY = BitqueryStreamingGraphql.parse "Data-for-token"

  QUERY = BitqueryStreamingGraphql::Client.parse <<-'GRAPHQL'
    query ($network: evm_network, $address: String!) {
      EVM(dataset: archive, network: $network) {
        address: Transfers(
          where: {Transfer: {Sender: {is: $address}}}
          limit: {count: 1}
        ) {
          Transfer {
            Sender
            Receiver
          }
        }
        token: Transfers(
          where: {Transfer: {Currency: {SmartContract: {is: $address}}}}
          limit: {count: 1}
        ) {
          Transfer {
            Sender
            Currency {
              Symbol
              SmartContract
              Name
              Decimals
            }
          }
        }
        calls: Calls(where: {Call: {To: {is: $address}}}, limit: {count: 1}) {
          Call {
            Signature {
              Signature
            }
          }
        }
      }
    }
  GRAPHQL

  private

  def query_graphql
    @address = params[:address]

    if @address.starts_with?('0x')
      result = BitqueryStreamingGraphql.instance.query_with_retry(QUERY, variables: { network: @network[:streaming], address: @address }).data.evm
      if result.token.any?
        @info = result.token.first.transfer
      elsif result.calls.any?
        @info = 'smart_contract'
      end
    end
  end


  def redirect_by_type
    if @info.try(:currency)
      change_controller! 'ethereum_streaming/token'
      elsif @info == 'smart_contract'
      change_controller! 'ethereum_streaming/smart_contract'
    end
  end


end