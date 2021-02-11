class Covid::CovidContinentController < ApplicationController
  layout 'tabs'
  before_action :set_codes

  REGIONS = {
    'Africa' => '002',
    'Europe' => '150',
    'North_America' => '021',
    'South_America' => '005',
    'Asia' => '142',
    'Oceania' => '009'
  }

  private

  def set_codes
    @continent_code = params[:code]
    @continent_region = REGIONS[@continent_code]
    @name = @continent_code.sub '_', ' '
  end
end
