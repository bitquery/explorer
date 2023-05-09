class ProxyGraphqlIdeController < ApplicationController

	def getquery

		uri = URI("#{ENV['BITQUERY_IDE_API']}/getquery/#{params[:queryid]}")
		req = Net::HTTP::Get.new(uri)

		req['Cookie'] = "_app_session_key=#{ENV['SESSION_ID']}"
		req['Accept'] = 'application/json'

		res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') { |http|
			http.request(req)
		}

		respond_to do |format|
			format.json {
				render json: res.body
			}
		end

	end

end
  