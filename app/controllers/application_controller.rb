class ApplicationController < ActionController::Base

  before_action :set_locale, :set_theme, :set_date, :set_feed

  def default_url_options
    {locale: I18n.locale == I18n.default_locale ? nil : I18n.locale}
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

  def set_date
    if params[:from] && !params[:from].empty?
      @from = "\"#{params[:from]}\""
    else
      @from = 'null'
    end

    if params[:till] && !params[:till].empty?
      @till = "\"#{params[:till]}\""
    else
      @till = 'null'
    end

    if params[:from].blank? && params[:till].blank?
      @from = "\"#{(Time.now - 29.days).strftime('%Y-%m-%d')}\""
      @till = "\"#{Time.now.strftime('%Y-%m-%d')}\""
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

    @bitquery_feed_item = {
      title: title,
      link: link
    }
  end
end
