class UtilityController < ApplicationController
  def set_locale
    session[:locale] ||= I18n.default_locale
    super
  end
  
  def graphql
    render layout: 'application'
  end
  
  def errors
    render 'utility/errors', formats: [:html], layout: 'application', status: :not_found
  end
end
