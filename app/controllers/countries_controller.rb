class CountriesController < ApplicationController
  def show
    @country = Country.friendly.find(params[:id])
  end

  def random
    redirect_to country_path(Country.all.sample)
  end

  def index
    @countries = Country.all
  end
end
