class Eos::NetworkController < ::NetworkController
  layout 'tabs'

  before_action :breadcrumb, :query_date

  QUERY =  BitqueryGraphql::Client.parse  <<-'GRAPHQL'
  query{
    eos{
      blocks(options:{desc: "date.date", limit: 1}){
        date {date}
      }
    }
  }
  GRAPHQL

  private
  def breadcrumb
    action_name != 'show' && @breadcrumbs << {name: t("tabs.#{controller_name}.#{action_name}.name")}
  end

  def query_date
    @block_date = BitqueryGraphql::Client.query(QUERY, variables: {}).data.eos.blocks[0].date.date
  end
end
