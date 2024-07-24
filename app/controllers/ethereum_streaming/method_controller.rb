module EthereumStreaming
  class MethodController < NetworkController
    before_action :set_signature, :query_date
    layout 'tabs'

    private

    QUERY = <<-GRAPHQL.freeze
      query ($network: evm_network, $method: String) {
        EVM(dataset: archive, network: $network) {
          Calls(
            where: {Call: {Signature: {SignatureHash: {is: $method}}}}
            limit: {count: 1}
          ) {
            Call {
              Signature {
                Name
                Signature
                SignatureHash
              }
            }
          }
        }
      }
    GRAPHQL

    def set_signature
      @signature = params[:signature]
    end

    def query_date
      method = ::Graphql::V2.query_with_retry(QUERY, variables: { method: @signature, network: @network[:streaming] },
                                                     context: { authorization: @streaming_access_token })

      if method.data.EVM.Calls.any?
        call_signature = method.data.EVM.Calls[0].Call.Signature

        @method_name = if call_signature.Name.present?
                         call_signature.Name
                       elsif call_signature.Signature.present?
                         call_signature.Signature
                       else
                         call_signature.SignatureHash
                       end
      else
        @method_name = ''
      end
    end
  end
end
