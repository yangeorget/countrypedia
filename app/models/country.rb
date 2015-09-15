require 'nokogiri'
require 'open-uri'
require 'html_truncator'
require 'httparty'
require 'webrick/httputils'
require 'weather-api'

class Country < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name

  def wikipedia_site
    "https://#{ I18n.locale }.wikipedia.org"
  end

  def wikipedia_url
    URI.escape("#{ wikipedia_site }/wiki/#{ I18n.t(name)}")
  end

  def wikipedia_doc
    html = Rails.cache.fetch(wikipedia_url, :expires_in => 1.day) do
      open(wikipedia_url).read
    end
    Nokogiri::HTML(html)
  end

  def wikipedia_info
    html = wikipedia_doc.xpath("//*[@id='mw-content-text']/p").to_s
    html = HTML_Truncator.truncate(html, 500)
    link_sanitizer = Rails::Html::LinkSanitizer.new
    link_sanitizer.sanitize(html)
  end

  def googlemaps_url 
    URI.escape("https://maps.googleapis.com/maps/api/staticmap?center=#{ I18n.t(name) }&key=AIzaSyCRckkdFPzcbgqL2-PAhmo6aEDNU8hITQM")
  end

  def flag
    "#{ code2.downcase }.png"
  end
  
  def restcountries_url 
    "https://restcountries.eu/rest/v1"
  end

  def restcountries_code_url
    "#{ restcountries_url}/alpha?codes=#{ code2 }"
  end

  def restcountries_code
    json = Rails.cache.fetch(restcountries_code_url, :expires_in => 1.day) do
          HTTParty.get(restcountries_code_url)[0]
    end
    json
  end

  def geochart_from_borders(borders)
    data = [
     ['Country', 'Neighbor'],
     [I18n.t(name), 0],
    ]
    borders.each do |code3|
      neighbor = Country.find_by_code3(code3.downcase)
      if neighbor
        data.push [I18n.t(neighbor.name), 1]
      end
    end
    data
  end

  def weather(woeid)
    Weather.lookup(woeid, Weather::Units::CELSIUS)
  end
end

