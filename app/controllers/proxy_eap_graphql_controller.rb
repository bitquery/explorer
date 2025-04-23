class ProxyEapGraphqlController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    api_key = ENV.fetch('EXPLORER_API_KEY') { nil }

    BitqueryLogger.extra_context query: params[:query],
                                 variables: params[:variables]
    BitqueryLogger.info %Q[==========> ProxyEapGraphqlController GraphQL request:
      Query: #{params[:query].inspect}
      Variables: #{params[:variables].inspect}
      Headers: #{request.headers.inspect}
    ]
    uri = URI(BITQUERY_EAP_GRAPHQL)
    begin
      res = Net::HTTP.post(uri,
                           { query: params[:query], variables: params[:variables] }.to_json,
                           { 'Content-Type' => 'application/json',
                             'Accept' => 'application/json',
                             'X-API-KEY' => api_key,
                             'Authorization' => session['streaming_access_token'] })

      unless res.is_a?(Net::HTTPSuccess)
        Rails.logger.error "EAP GraphQL failed with status #{res.code}: #{res.body}"
        return render json: { error: "EAP GraphQL request failed", status: res.code }, status: res.code
      end

      respond_to do |format|
        format.json { render json: res.body }
      end
    rescue StandardError => e
      Rails.logger.error "EAP GraphQL error: #{e.message}"
      render json: { error: "Internal server error: #{e.message}" }, status: :internal_server_error
    end
  end
end