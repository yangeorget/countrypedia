require 'nokogiri'
require 'open-uri'
require 'html_truncator'
require 'httparty'
require 'webrick/httputils'

class City < ActiveRecord::Base
  extend FriendlyId
  belongs_to :country
  friendly_id :name

  def geonames_url
    "http://www.geonames.org/#{ geonames_id }/#{ name}.html"
  end

  def geonames_html
    open(geonames_url).read
  end

  def geonames_name
    Nokogiri::HTML(geonames_html).xpath("//*[@id=\"infowin\"]/div[1]/b").to_s
  end
end

