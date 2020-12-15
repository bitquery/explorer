class UtilityController < ApplicationController


  def set_locale

    session[:locale] ||= I18n.default_locale
    super

  end

end
