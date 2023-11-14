class EthereumStreaming::AddressController < NetworkController
  layout 'tabs'

  before_action :query_graphql, :redirect_by_type

  # QUERY = Graphql::V2.parse "Data-for-token"

  QUERY = Graphql::V2::Client.parse <<-'GRAPHQL'
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

    if @address.starts_with?('0x')
      result = Graphql::V2.instance.query_with_retry(QUERY, variables: { network: @network[:streaming], address: @address }, context: {'Authorization': @streaming_access_token}).data.evm
      if result.token.any?
        @info = result.token.first.transfer
        @check_token = 'token'
        @fungible = @info.currency.fungible
      elsif result.calls.any?
        @info = result.address.any? ? result.address.first.transfer : @address
        @check_call = 'calls'
      end
    end
  end


  def redirect_by_type
    if @info.try(:currency)
      if @fungible == false
        redirect_to controller: 'ethereum_streaming/token', action: 'nft_smart_contract'
        return
      end
      change_controller! 'ethereum_streaming/token'
    elsif @info == 'smart_contract'
      change_controller! 'ethereum_streaming/smart_contract'
    end
  end



end