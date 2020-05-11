class Covid::CovidCountryController < ApplicationController

  layout 'tabs'
  before_action :set_codes

  private

  def set_codes
    @code = params[:code]
    @name = params[:name]
  end

end
