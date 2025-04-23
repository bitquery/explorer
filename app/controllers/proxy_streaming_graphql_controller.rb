class ProxyStreamingGraphqlController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    api_key = ENV.fetch('EXPLORER_API_KEY') { nil }

    BitqueryLogger.extra_context query: params[:query],
                                 variables: params[:variables]


    BitqueryLogger.info %Q[========> ProxyStreamingGraphqlController GraphQL request:
      Query: #{params[:query].inspect}
      Variables: #{params[:variables].inspect}
      Headers: #{request.headers.inspect}
    ]
    uri = URI(BITQUERY_STREAMING_GRAPHQL)
    res = Net::HTTP.post(uri,
                         { query: params[:query], variables: params[:variables] }.to_json,
                         { 'Content-Type' => 'application/json',
                           'Accept' => 'application/json',
                           'X-API-KEY' => api_key, 'Authorization' => session['streaming_access_token'] })

    respond_to do |format|
      format.json do
        render json: res.body
      end
    end
  end
end
