class ApplicationController < ActionController::Base

  before_action :set_locale, :set_theme, :set_date, :set_feed, :get_session_streaming_token

  def default_url_options
    {locale: I18n.locale == I18n.default_locale ? nil : I18n.locale}
  end

  def innovation_in_blockchain?
    @network && BLOCKCHAIN_BY_NAME[@network['network']]['innovation'] == true || false
  end

  private

  def extract_locale_from_accept_language_header
    locale = request.env['HTTP_ACCEPT_LANGUAGE'] && request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    locale && I18n.available_locales.include?(locale.to_sym) ? locale.to_sym : nil
  end

  def set_theme
    if params[:theme]
      session[:theme] = params[:theme]
    elsif session[:theme] && !session[:theme].empty?
    else
      session[:theme] = 'light'
    end

    @theme = session[:theme]
  end

  def dark?
    @theme == 'dark'
  end

  def date?(string)
    # YYYY-MM-DD
    !!(string =~ /^\d{4}-\d{2}-\d{2}$/)
  end

  def set_date
    @from = params[:from]
    @till = params[:till]

    @from = nil unless date?(@from)
    @till = nil unless date?(@till)

    @from = "\"#{@from}\"" if @from.present?
    @till = "\"#{@till}\"" if @till.present?

    if params['network'] && DATE_LIMITS[params["network"]["tag"]] && DATE_LIMITS[params["network"]["tag"]][params[:controller]] && DATE_LIMITS[params["network"]["tag"]][params[:controller]][params[:action]]
      @from = "\"#{(Date.today - DATE_LIMITS[params["network"]["tag"]][params[:controller]][params[:action]]).strftime('%Y-%m-%d')}\"" if @from.blank?
      @till = "\"#{Time.now.strftime('%Y-%m-%d')}\"" if @till.blank?
    else
      @from = "\"#{(Time.now - 7.days).strftime('%Y-%m-%d')}\"" if @from.blank?
      @till = "\"#{Time.now.strftime('%Y-%m-%d')}\"" if @till.blank?
    end
  end

  def set_locale

    I18n.locale =
        if params[:locale]
          locale = params[:locale].to_sym
          redirect_to({locale: nil, status: 301}.merge(request.query_parameters)) if locale==I18n.default_locale
          locale
        elsif session[:locale]
          I18n.default_locale
        else
          locale = extract_locale_from_accept_language_header || I18n.default_locale
          cors_set_access_control_headers
          redirect_to(locale: locale) unless locale==I18n.default_locale
          locale
        end

    session[:locale] = I18n.locale

    Rails.application.routes.default_url_options[:locale] = (I18n.locale == I18n.default_locale ? nil : I18n.locale)

  end

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Allow-Headers'] = '*'
    headers['Access-Control-Expose-Headers'] = '*'
    headers['Access-Control-Max-Age'] = "1728000"
    headers.delete('X-Frame-Options')
  end

  def change_controller! controller_name
    redirect_to  params.permit!.merge({controller: controller_name})
  end

  def set_feed
    rss = Rss::Parse.call('https://bitquery.io/feed')
    return unless rss

    random_item = rss.entries.sample

    title = random_item.title
    link = random_item.url

    @bitquery_feed_item = [{
                             title: title,
                             link: link
                           },
                           {
                             title: "NFT APIs",
                             link: "https://bitquery.io/products/nft-api"
                           },
                           {
                             title: "Crypto News",
                             link: "https://coincodecap.com/?utm_source=bitquery"
                           }].sample
  end
  def get_session_streaming_token
    get_streaming_access_token if session['streaming_access_token'].blank? || session['streaming_expires_in'] >= Time.now
    @streaming_access_token = session['streaming_access_token']
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
      session['streaming_access_token'] = body['access_token']
      session['streaming_expires_in'] = Time.now +  body['expires_in'].seconds
    else
      nil
    end
  end
end

