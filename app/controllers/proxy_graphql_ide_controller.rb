class ProxyGraphqlIdeController < ApplicationController
  def getquery
    uri = URI("#{ENV.fetch('BITQUERY_IDE_API') { nil }}/getquery/#{params[:queryid]}")
    req = Net::HTTP::Get.new(uri)

    req['Cookie'] = "_app_session_key=#{ENV.fetch('SESSION_ID') { nil }}"
    req['Accept'] = 'application/json'

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(req)
    end

    respond_to do |format|
      format.json do
        render json: res.body.gsub("combined","realtime").gsub("archive","realtime")
      end
    end
  end
end
