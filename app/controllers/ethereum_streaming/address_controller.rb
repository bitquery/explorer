class EthereumStreaming::AddressController < NetworkController
  layout 'tabs'

  before_action :query_graphql, :redirect_by_type

  QUERY = BitqueryStreamingGraphql::Client.parse <<-'GRAPHQL'
    query ($network: evm_network, $token: String!) {
      EVM(dataset: archive, network: $network) {
        Transfers(
          where: {Transfer: {Currency: {SmartContract: {is: $token}}}}
          limitBy: {}
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
          }
        }
      }
    }
  GRAPHQL

  QUERY_CURRENCIES = BitqueryStreamingGraphql::Client.parse <<-'GRAPHQL'
   query($network: EthereumNetwork!, $address: String!) {
              ethereum(network: $network) {
                address(address: {is: $address}){
                  address 
                  annotation
                  
                  smartContract {
                    contractType
                    currency{
                      symbol
                      name
                      decimals
                      tokenType
                    }
                  }
                  balance
                }
    						tin: transfers(receiver: {is: $address}, options: {desc: "count", limit: 100}){
      							currency {
                      address
                      symbol
                      name
                    }
      							count
    						}
    						tout: transfers(sender: {is: $address}, options: {desc: "count", limit: 100}){
      							currency {
                      address
                      symbol
                      name
                    }
      							count
    						}
              }
            }
  GRAPHQL

  private

  def query_graphql
    @address = params[:address]
    query = action_name == 'money_flow' ? QUERY_CURRENCIES : QUERY
    if @address.starts_with?('0x')
      result = BitqueryStreamingGraphql.instance.query_with_retry(query, variables: { network: @network[:streaming], address: @address }).data.evm.transfers
      @info = result.transfer.currency.smart_contract
      all_t = (result.try(:tin) || []) + (result.try(:tout) || [])
      @currencies = all_t.map(&:currency).sort_by { |c| c.transfer.currency.smart_contract == '-' ? 0 : 1 }.uniq { |x| x.transfer.currency.smart_contract }
    end
  end

  def redirect_by_type
    if sc = @info.try(:smart_contract)
      change_controller! (sc.currency ? 'ethereum_streaming/token' : 'ethereum_streaming/smart_contract')
    end
  end

end