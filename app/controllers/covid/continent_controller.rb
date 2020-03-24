class Covid::ContinentController < ApplicationController

  REGIONS = {
      'Africa' => '002',
      'Europe' => '150',
      'North_America' => '021',
      'South_America' => '005',
      'Asia' => '142',
      'Oceania' => '009'
  }

  def index
    @continent_code = params[:code]
    @continent_region = REGIONS[@continent_code]
    @name = @continent_code.sub '_',' '
    @header = "#{@name} Continent COVID-2019 Data"
  end
end
