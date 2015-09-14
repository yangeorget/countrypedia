class CountriesController < ApplicationController
  # GET /countries/1
  # GET /countries/1.json
  def show
    @country = Country.friendly.find(params[:id])
    @language = @country.language
  end
end
