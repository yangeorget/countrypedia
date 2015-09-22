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
    url = "#{ wikipedia_site }/wiki/#{ I18n.t(name)}"
    redirect = WebRedirect.find_by_from(url)
    if (redirect)
      url = redirect.to
    end
    URI.escape(url)
  end

  def wikipedia_doc
    html = Rails.cache.fetch(wikipedia_url, :expires_in => 1.day) do
      open(wikipedia_url).read
    end
    Nokogiri::HTML(html)
  end

  def wikipedia_info(size)
    html = wikipedia_doc.xpath("//*[@id='mw-content-text']/p").to_s
    html = HTML_Truncator.truncate(html, size)
    link_sanitizer = Rails::Html::LinkSanitizer.new
    link_sanitizer.sanitize(html)
  end

  def googlemaps_url(hash)
    params = {
      :center => "#{ name } country",
      :language => I18n.locale,
      :key => "AIzaSyCRckkdFPzcbgqL2-PAhmo6aEDNU8hITQM",
      :format => "jpg"
    }.merge(hash)
    URI.escape("https://maps.googleapis.com/maps/api/staticmap?#{ params.to_query }")
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
      logger.debug("fetching #{ restcountries_code_url }")
      HTTParty.get(restcountries_code_url)[0]
    end
    logger.debug("#{ restcountries_code_url } returns #{ json.to_s }")
    json
  end

  def googleimagessearch_url
    "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&as_filetype=jpg&hl=en&imgsz=large&imgtype=photo&rsz=3&q=#{ name }+travel" 
  end

  def googleimagessearch
    json = Rails.cache.fetch(googleimagessearch_url, :expires_in => 1.day) do
      logger.debug("fetching #{ googleimagessearch_url }")
      HTTParty.get(googleimagessearch_url, {format: :json})['responseData']['results']
    end
    json
  end   

  def openexchangerates_url
    "https://openexchangerates.org/api/latest.json?app_id=780adb29f52c4bbc92cadac35bace194"
  end
  
  def openexchangerates
    json = Rails.cache.fetch(openexchangerates_url, :expires_in => 1.day) do
      logger.debug("fetching #{ openexchangerates_url }")
      HTTParty.get(openexchangerates_url)['rates']
    end
    json
  end
  
  def borders(codes)
    countries = []
    codes.each do |code| 
      country = Country.find_by_code3(code.downcase) 
      countries.append(country)
      logger.debug("#{ code } #{ country }")
    end
    countries
  end

  def weather
    weather = Rails.cache.fetch(woeid, :expires_in => 1.hour) do
      Weather.lookup(woeid, Weather::Units::CELSIUS)
    end
    weather
  rescue RuntimeError => e
    nil
  end
end

