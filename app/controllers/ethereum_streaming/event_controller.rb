class EthereumStreaming::EventController < NetworkController
  before_action :set_signature, :query_date
  layout 'tabs'

  QUERY = <<-'GRAPHQL'
      query ($network: evm_network, $method: String) {
        EVM(dataset: archive, network: $network) {
          Events(
            where: {Log: {Signature: {SignatureHash: {is: $method}}}}
            limit: {count: 1}
          ) {
            ChainId
            Log{
              Signature{
              Name                
              Signature
              SignatureHash}
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
    event = ::Graphql::V2.query_with_retry(QUERY, variables: { method: @signature, network: @network[:streaming] }, context: { authorization: @streaming_access_token })

    if event.data.EVM.Events.any?
      log_signature = event.data.EVM.Events[0].Log.Signature

      @event_name = if log_signature.Name && !log_signature.Name.empty?
                      log_signature.Name
                    elsif log_signature.Signature && !log_signature.Signature.empty?
                      log_signature.Signature
                    else
                      log_signature.SignatureHash
                    end
    end
  end

end
