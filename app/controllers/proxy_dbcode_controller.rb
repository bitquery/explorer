class ProxyDbcodeController < ApplicationController
  # protect_from_forgery with: :null_session

  def index
    dashboard_url = params[:dashbord_url]

    BitqueryLogger.extra_context(dashboard_url:)

    uri = URI("#{BITQUERY_IDE_API}/dbcode/#{dashboard_url}")

    if uri.scheme == 'https'
      http = Net::HTTP.new(uri.host, 443)
      http.use_ssl = true
    else
      http = Net::HTTP.new(uri.host, uri.port)
    end

    res = http.get(uri, { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })

    respond_to do |format|
      format.json do
        render json: res.body
      end
    end
  end
end
