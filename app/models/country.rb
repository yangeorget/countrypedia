require 'nokogiri'
require 'open-uri'

class Country < ActiveRecord::Base
  def wikipedia
    doc = Nokogiri::HTML(open("https://fr.wikipedia.org/wiki/Wikip%C3%A9dia:Accueil_principal"))
  end
end
