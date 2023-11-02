class ProxyStreamingGraphqlController < ApplicationController

	def index
		if  session['streaming_access_token'].blank?
			Acc
		end
	  api_key = ENV['EXPLORER_API_KEY']
  
	  BitqueryLogger.extra_context query: params[:query],
								   variables: params[:variables]
  
	  uri = URI(BITQUERY_STREAMING_GRAPHQL)
	  res = Net::HTTP.post(uri,
						   { query: params[:query], variables: params[:variables] }.to_json,
						   { 'Content-Type' => 'application/json',
							 'Accept' => 'application/json',
							 'Authorization' => api_key })
  
	  respond_to do |format|
		format.json {
		  render json: res.body
		}
	  end
	end
  
  end
  