class Covid::CountryController < ApplicationController

  def index
    @code = params[:code]
    @name = params[:name]
    @header = "#{@name} COVID-2019 Data"
  end
end
