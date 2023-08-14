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
            Currency {
              SmartContract
              Symbol
              Name
              Decimals
              ProtocolName
            }
            Sender
          }
          ChainId
        }
        smart_contract: Transfers(
          where: {Transfer: {Currency: {SmartContract: {is: $address}}}}
          limit: {count: 1}
        ) {
          Transfer {
            Currency {
              SmartContract
              Symbol
              Name
              Decimals
              ProtocolName
            }
            Sender
          }
          ChainId
        }
      }
    }

  GRAPHQL

  private

  def query_graphql
    @address = params[:address]

    if @address.starts_with?('0x')
      result = BitqueryStreamingGraphql.instance.query_with_retry(QUERY, variables: { network: @network[:streaming], address: @address }).data.evm
      if result.address.any?
        @info = result.address.first.transfer.sender
      elsif result.smart_contract.any?
        @info = result.smart_contract.first.transfer.currency.smart_contract
      end
    end
  end


  def redirect_by_type
    sc = @info.try(:currency)
    if sc
      change_controller! (sc.currency ? 'ethereum_streaming/token' : 'ethereum_streaming/smart_contract')
    end
  end


end