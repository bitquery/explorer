class EthereumStreaming::TokenController < EthereumStreaming::AddressController

  before_action :is_native

  def smart_contract
    render 'ethereum_streaming/smart_contract/show'
  end

  def nft
    render 'ethereum_streaming/token/nft_smart_contract'
  end

  def methods
    render 'ethereum_streaming/smart_contract/methods'
  end

  def events
    render 'ethereum_streaming/smart_contract/events'
  end

  def transactions
    render 'ethereum_streaming/smart_contract/transactions'
  end

  def inflow
    render 'ethereum_streaming/address/inflow'
  end

  def outflow
    render 'ethereum_streaming/address/outflow'
  end

  def calls_contracts
    render 'ethereum_streaming/address/calls_contracts'
  end

  private

  def is_native
    @token = params[:address]
    @id= params[:id]
    @native_token = native_token?
    @token_info = !@native_token && @info.smart_contract
  end

  def native_token?
    @address == @network[:currency]
  end

  def redirect_by_type
    return if native_token?
    if !(sc = @info.try(:smart_contract))
      change_controller!  'ethereum_streaming/address'
    elsif !sc.try(:currency)
    #  change_controller! 'ethereum_streaming/smart_contract'
    end
  end

end
