class City < ActiveRecord::Base
  extend FriendlyId
  belongs_to :country
  friendly_id :name

  def geonames_url
    "http://www.geonames.org/#{ geonames_id }/#{ name }.html"
  end

  def geonames_info
    xpath = "//table[2]/tr[position() > 1]/td/a[@href='#{ geonames_url }']/parent::td/parent::tr/td"
    tds = Nokogiri::HTML(country.geonames_largestcities_page).xpath(xpath)
    population = tds[2].text
    latlng = tds[3].text.split('/')
    latitude = latlng[0].strip
    longitude = latlng[1].strip
    {:population => population, :latitude => latitude, :longitude => longitude}
  end

  def google_staticmaps_url(type, width, height)
    Util::Google.staticmaps_url(type, width, height, "#{ name } #{ self.country.name }".gsub("-", " "))
  end

  def google_images_search(nb)
    Util::Google.images_search(nb, "view #{ name } #{ self.country.name }".gsub("-", " "))
  end
end

