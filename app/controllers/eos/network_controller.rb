class Eos::NetworkController < ::NetworkController
  layout 'tabs'

  before_action :breadcrumb, :query_date

  QUERY =  Graphql::V1::Client.parse  <<-'GRAPHQL'
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
    @block_date = Graphql::V1.instance.query_with_retry(QUERY, variables: {}, context: {'Authorization': @streaming_access_token}).data.eos.blocks[0].date.date
  end
end
