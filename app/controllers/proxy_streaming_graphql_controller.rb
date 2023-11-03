class ProxyStreamingGraphqlController < ApplicationController

  skip_forgery_protection
  # куда запихнуть client_id и client_secret и  streaming_access_token где мне их взять? чем они вобще все отличаются и почему их три?
  # где храниться токен
  def index
    if session['streaming_access_token'].blank?
      api_key = get_streaming_access_token
    else
      api_key = session['streaming_access_token']
    end
    perform_request(api_key)
  end

  def perform_request(api_key, count = 0)
    BitqueryLogger.extra_context query: params[:query],
                                 variables: params[:variables]

    uri = URI(BITQUERY_STREAMING_GRAPHQL)
    res = Net::HTTP.post(uri,
                         { query: params[:query], variables: params[:variables] }.to_json,
                         { 'Content-Type' => 'application/json',
                           'Accept' => 'application/json',
                           'Authorization' => api_key })
    if check_error(res)
      api_key = get_streaming_access_token
      count += 1
      raise '>>>>Error no key <<<<' if count >5 # TODO what i need do??
      perform_request(api_key, count)

      # сколько раз надо запрашивать ключ? тут надо что-то вроде остановки рекурсии как это сделать?
    else
      respond_to do |format|
        format.json { render json: res.body }
        #   как посмотреть мой респонс (опять забыла)
      end
    end
  end

  def check_error(response)
    [402, 403, 407, 423, 424].include?(response.code.to_i)
    # этого хватит для проверки ошибки о токене?
  end

  def get_streaming_access_token
    url = URI("https://oauth2.bitquery.io/oauth2/token")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/x-www-form-urlencoded"
    request.body = "grant_type=client_credentials&client_id=#{ENV['CLIENT_ID']}&client_secret=#{ENV['CLIENT_SECRET']}&scope=api"

    response = https.request(request)
    if response.is_a?(Net::HTTPSuccess)
      body = JSON.parse(response.body)
      session['streaming_access_token'] = body['streaming_access_token']  #TODO выбрать правильный key
      # что мне тут делать со тветом? куда что присваивать?
    else
      # как мне обработать ошибку?
      nil
    end
  end
end
