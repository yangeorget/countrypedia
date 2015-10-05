class CitiesController < ApplicationController
  def show
      @city = City.friendly.find(params[:id])
  end

  def random
    city = City.all.sample
    redirect_to country_city_path(city.country, city)
  end

  def index
    @cities = City.all.sort { |a,b| I18n.t(a.name) <=> I18n.t(b.name) }
    @glossary = {}
    @cities.each do |city|
      letter = I18n.transliterate(t(city.name))[0]
      @glossary[letter] = @glossary[letter] || []
      @glossary[letter].append(city)
    end
  end
end
