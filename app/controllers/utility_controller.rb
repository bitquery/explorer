class UtilityController < ApplicationController
  def set_locale
    session[:locale] ||= I18n.default_locale
    super
  end
  
  def graphql
    render layout: 'application'
  end
  
  def errors
    render layout: 'application'
  end
end
