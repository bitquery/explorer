class Tron::Trc10tokenController < NetworkController
  layout 'tabs'

  before_action :token, :breadcrumb

  QUERY = BitqueryGraphql::Client.parse <<-'GRAPHQL'
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
    result = BitqueryGraphql::Client.query(QUERY, variables: { token: @token }).data.tron.transfers.first
    @info = result.currency
  rescue Net::ReadTimeout => e
    Raven.capture_exception e
    sleep(1)
    retry
  end

  def breadcrumb
    action_name == 'show' ?
      @breadcrumbs.last[:name] = "#{t("tabs.#{controller_name}.#{action_name}.name")}: #{@info.symbol}" :
      @breadcrumbs[-2][:name] = "#{t("tabs.#{controller_name}.#{action_name}.name")}: #{@info.symbol}"
  end
end
