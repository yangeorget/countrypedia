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

  def googlemaps_query
    "#{ name } #{ self.country.name }".gsub("-", " ")
  end

  def googlemaps_url(hash)
    params = {
      :center => googlemaps_query,
      :language => I18n.locale,
      :key => "AIzaSyCRckkdFPzcbgqL2-PAhmo6aEDNU8hITQM",
      :format => "jpg"
    }.merge(hash)
    url = URI.escape("https://maps.googleapis.com/maps/api/staticmap?#{ params.to_query }")
    logger.debug("Google Maps URL=#{ url }")
    url
  end

  def googleimagessearch_url
    "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&as_filetype=jpg&hl=en&imgsz=large&imgtype=photo&rsz=3&q=#{ name }+travel" 
  end

  def googleimagessearch
    Rails.cache.fetch(googleimagessearch_url, :expires_in => 1.day) do
      HTTParty.get(googleimagessearch_url, {format: :json})['responseData']['results']
    end
  end

  def google_time_url(timestamp)
    info = geonames_info
    "https://maps.googleapis.com/maps/api/timezone/json?key=AIzaSyCRckkdFPzcbgqL2-PAhmo6aEDNU8hITQM&location=#{ info[:latitude] },#{ info[:longitude] }&timestamp=#{ timestamp }&language=#{ I18n.locale }"
  end

  def google_time(timestamp)
    HTTParty.get(google_time_url(timestamp))
  end
end

