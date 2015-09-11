require 'nokogiri'
require 'open-uri'

class Country < ActiveRecord::Base
  belongs_to :language

  def wikipedia_url
    "https://#{ language.code }.wikipedia.org/wiki/#{ name}"
  end

  def wikipedia
    doc = Nokogiri::HTML(open(wikipedia_url))
  end
end
