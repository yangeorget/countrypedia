require 'nokogiri'
require 'open-uri'
require 'html_truncator'
require 'httparty'
require 'webrick/httputils'
require 'weather-api'

class Country < ActiveRecord::Base
  extend FriendlyId
  has_many :cities
  friendly_id :name

  def geonames_url
    "http://www.geonames.org/countries/#{ code2.upcase }/#{ name }.html"
  end

  def geonames_largestcities_url
    "http://www.geonames.org/#{ code2 }/largest-cities-in-#{ name }.html"
  end

  def geonames_largestcities_page
    Rails.cache.fetch(geonames_largestcities_url, :expires_in => 1.day) do
      open(geonames_largestcities_url).read
    end
  end

  def geonames_largestcities
    Nokogiri::HTML(geonames_largestcities_page).xpath("//table[2]/tr[position() > 1]/td[2]/a[1]/text()").map{ |node| node.to_s} 
  end

  def wikipedia_url
    url = "https://#{ I18n.locale }.wikipedia.org/wiki/#{ I18n.t(name)}"
    redirect = WebRedirect.find_by_from(url)
    if (redirect)
      url = redirect.to
    end
    URI.escape(url)
  end

  def wikipedia_page
    Rails.cache.fetch(wikipedia_url, :expires_in => 1.day) do
      open(wikipedia_url).read
    end
  end

  def wikipedia_summary(page)
    wikipedia_paragraphs(page, "//p[parent::div[1][@id='mw-content-text']]")
  end

  def wikipedia_block(page, id)
    wikipedia_paragraphs(page, "//p[preceding-sibling::h2[1][span='#{ id }']]")
  end

  def wikipedia_paragraphs(page, xpath)
    #logger.debug("xpath=#{ xpath }")
    nodes = Nokogiri::HTML(page).xpath(xpath).first(3) 
    #logger.debug(nodes.to_s)
    paragraphs = []
    nodes.each do |node|
      if node
        paragraphs.append(Rails::Html::FullSanitizer.new.sanitize(node.to_s))
      end
    end
    paragraphs
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
  
  def restcountries_code_url
    "https://restcountries.eu/rest/v1/alpha?codes=#{ code2 }"
  end

  def restcountries_code
    json = Rails.cache.fetch(restcountries_code_url, :expires_in => 1.day) do
      HTTParty.get(restcountries_code_url)[0]
    end
    logger.debug("#{ restcountries_code_url } returns #{ json.to_s }")
    if json == nil 
      json = { 
        'alpha2Code' => nil,
        'alpha3Code' => nil,
        'area' => nil,
        'borders' => [],
        'callingCodes' => [],
        'capital' => nil,
        'currencies' => [],
        'demonym' => nil,
        'gini' => nil,
        'languages' => [],
        'latlng' => [nil, nil],
        'population' => nil,
        'region' => nil,
        'subregion' => nil,
        'topLevelDomain' => [nil]
      }
    end
    json
  end

  def googleimagessearch_url
    "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&as_filetype=jpg&hl=en&imgsz=large&imgtype=photo&rsz=3&q=#{ name }+travel" 
  end

  def googleimagessearch
    Rails.cache.fetch(googleimagessearch_url, :expires_in => 1.day) do
      HTTParty.get(googleimagessearch_url, {format: :json})['responseData']['results']
    end
  end   

  def openexchangerates_url
    "https://openexchangerates.org/api/latest.json?app_id=780adb29f52c4bbc92cadac35bace194"
  end
  
  def openexchangerates
    Rails.cache.fetch(openexchangerates_url, :expires_in => 1.day) do
      HTTParty.get(openexchangerates_url)['rates']
    end
  end
  
  def borders(codes)
    countries = []
    codes.each do |code| 
      country = Country.find_by_code3(code.downcase) 
      countries.append(country)
    end
    countries
  end

  def weather
    Rails.cache.fetch(woeid, :expires_in => 1.hour) do
      Weather.lookup(woeid, Weather::Units::CELSIUS)
    end
  rescue RuntimeError => e
    nil
  end
end

