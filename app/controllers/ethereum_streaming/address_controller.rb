class EthereumStreaming::AddressController < NetworkController
  layout 'tabs'

  before_action :query_graphql, :redirect_by_type

  # QUERY = BitqueryStreamingGraphql.parse "Data-for-token"

  QUERY = BitqueryStreamingGraphql::Client.parse <<-'GRAPHQL'
    query ($network: evm_network, $address: String!) {
      EVM(dataset: archive, network: $network) {
        Transfers(where: {Transfer: {Sender: {is: $address}}}, limit: {count: 1}) {
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

    query = QUERY
    if @address.starts_with?('0x')
      result = BitqueryStreamingGraphql.instance.query_with_retry(QUERY, variables: { network: @network[:streaming], address: @address }).data.evm.transfers
      @info = result.first.transfer.sender
      #     all_t = (result.try(:tin) || []) + (result.try(:tout) || [])
      #     @currencies = all_t.map(&:currency).sort_by { |c| c.address == '-' ? 0 : 1 }.uniq { |x| x.address }
    end
  end

  #
  def redirect_by_type
    if sc = @info.try(:smart_contract)
      change_controller! (sc.currency ? 'ethereum_streaming/token' : 'ethereum_streaming/smart_contract')
    end
  end

end