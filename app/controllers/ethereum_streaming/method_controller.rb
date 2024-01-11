class EthereumStreaming::MethodController < NetworkController
  before_action :set_signature,:query_date
  layout 'tabs'

  private


  QUERY = <<-'GRAPHQL'
      query ($network: evm_network, $method: String) {
        EVM(dataset: archive, network: $network) {
          Calls(
            where: {Call: {Signature: {SignatureHash: {is: $method}}}}
            limit: {count: 1}
          ) {
            Call {
              Signature {
                Name
              }
            }
          }
        }
      }
  GRAPHQL

  private

  def set_signature
    @signature = params[:signature]
  end

  def query_date
    method = ::Graphql::V2.query_with_retry(QUERY, variables: { method: @signature,
                                                               network: @network[:streaming] }, context: { authorization: @streaming_access_token })
    @method_name = method.data.EVM.Calls[0].Call.Signature.Name
  end
end
