class CountriesController < ApplicationController
  def show
    @country = Country.friendly.find(params[:id])
  end

  def random
    redirect_to country_path(Country.all.sample)
  end

  def index
    @countries = Country.all.sort { |a,b| I18n.t(a.name) <=> I18n.t(b.name) }
  end
end
