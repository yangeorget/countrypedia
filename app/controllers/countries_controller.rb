class CountriesController < ApplicationController
  def show
    @country = Country.friendly.find(params[:id])
  end

  def random
    redirect_to country_path(Country.all.sample)
  end

  def index
    @countries = Country.all.sort { |a,b| I18n.translate(a.name, I18n.locale) <=> I18n.translate(b.name, I18n.locale) }
  end
end
