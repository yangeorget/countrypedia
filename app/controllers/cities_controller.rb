class CitiesController < ApplicationController
  def show
      @city = City.friendly.find(params[:id])
  end

  def random
    city = City.all.sample
    redirect_to country_city_path(city.country, city)
  end
end
