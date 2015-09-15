class CountriesController < ApplicationController
  def show
    @country = Country.friendly.find(params[:id])
  end

  def index
    @countries = Country.all
  end
end
