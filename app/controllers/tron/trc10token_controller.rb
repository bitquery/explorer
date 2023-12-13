class Tron::Trc10tokenController < NetworkController
  layout 'tabs'

  before_action :token, :breadcrumb

  QUERY = <<-'GRAPHQL'
   query ( $token: String!){
                    tron{
                      transfers(
                        currency: {is: $token}
                        ) {
             currency {
                            address
                            symbol
                            tokenId
                            tokenType
                          }
                      }
                    }
                  }
  GRAPHQL

  def transfers
    render 'tron/trc20token/transfers'
  end

  def senders
    render 'tron/trc20token/senders'
  end

  def receivers
    render 'tron/trc20token/receivers'
  end

  def trades
    render 'tron/trc20token/trades'
  end

  private

  def token
    @token = params[:address]
    result = Graphql::V1.query_with_retry(QUERY, variables: { token: @token }, context: { authorization: @streaming_access_token }).data.tron.transfers.first
    @info = result.currency
  end

  def breadcrumb
    action_name == 'show' ?
      @breadcrumbs.last[:name] = "#{t("tabs.#{controller_name}.#{action_name}.name")}: #{@info.symbol}" :
      @breadcrumbs[-2][:name] = "#{t("tabs.#{controller_name}.#{action_name}.name")}: #{@info.symbol}"
  end
end
