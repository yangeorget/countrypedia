require 'httparty'

class City < ActiveRecord::Base
  extend FriendlyId
  belongs_to :country
  friendly_id :name

  def geonames_url
    "http://www.geonames.org/#{ geonames_id }/#{ name }.html"
  end

  def geonames_largestcities_url
    "http://www.geonames.org/#{ country.code2 }/largest-cities-in-#{ country.name }.html"
  end

  def geonames_largestcities_page
    Rails.cache.fetch(geonames_largestcities_url, :expires_in => 1.day) do
      open(geonames_largestcities_url).read
    end
  end

  def geonames_info
    xpath = "//table[2]/tr[position() > 1]/td/a[@href='#{ geonames_url }']/parent::td/parent::tr/td"
    tds = Nokogiri::HTML(geonames_largestcities_page).xpath(xpath)
    population = tds[2].text
    latlng = tds[3].text.split('/')
    latitude = latlng[0].strip
    longitude = latlng[1].strip
    {:population => population, :latitude => latitude, :longitude => longitude}
  end

  def googlemaps_url(hash)
    params = {
      :center => "#{ name } #{ self.country.name }".gsub("-", " "),
      :language => I18n.locale,
      :key => "AIzaSyCRckkdFPzcbgqL2-PAhmo6aEDNU8hITQM",
      :format => "jpg"
    }.merge(hash)
    url = URI.escape("https://maps.googleapis.com/maps/api/staticmap?#{ params.to_query }")
    logger.debug("Google Maps URL=#{ url }")
    url
  end

  def googleimagessearch
    params = {
      :fileType => "jpg",
      :filter => "1",
      :hl => "en",
      :imgColorType => "color",
      :imgType => "photo",
      :num => "4",
      :safe => "high",
      :searchType =>"image",
      :key => "AIzaSyCRckkdFPzcbgqL2-PAhmo6aEDNU8hITQM",
      :cx => "009539199191619195333:li9wvueep3e",
      :q => "view city #{ name } #{ self.country.name }".gsub("-", " ")
    }
    url = "https://www.googleapis.com/customsearch/v1?#{ params.to_query }"     
    logger.debug("Google Custom Search URL=#{ url }")
    Rails.cache.fetch(url, :expires_in => 1.day) do
      HTTParty.get(url)['items'].map { |json| json['link'] }
    end
  end

  def google_time_url(timestamp)
    info = geonames_info
    params = {
      :key => "AIzaSyCRckkdFPzcbgqL2-PAhmo6aEDNU8hITQM",
      :location => "#{ info[:latitude] },#{ info[:longitude] }",
      :timestamp => "#{ timestamp }",
      :language => "#{ I18n.locale }"
    }
    "https://maps.googleapis.com/maps/api/timezone/json?#{ params.to_query }"
  end

  def google_time(timestamp)
    HTTParty.get(google_time_url(timestamp))
  end

  def weather(latitude, longitude)
    ForecastIO.forecast(latitude, longitude, params: { lang: I18n.locale, units: 'si', exclude: "minutely,daily" })
  end
end

