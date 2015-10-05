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
    Util::Web.get(geonames_largestcities_url)
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
    Util::Web.get(wikipedia_url)
  end

  def wikipedia_summary(page)
    Util::Wikipedia.paragraphs(page, "//p[parent::div[1][@id='mw-content-text']]", 3)
  end

  def wikipedia_block(page, id)
    Util::Wikipedia.paragraphs(page, "//p[preceding-sibling::h2[1][span='#{ id }']]", 3)
  end

  def google_staticmaps_url(type, width, height)
    Util::Google.staticmaps_url(type, width, height, "#{ name } country".gsub("-", " "))
  end

  def google_images_search(nb)
    Util::Google.images_search(nb, "landscape #{ name }".gsub("-", " "))
  end
  
  def borders(codes)
    countries = []
    codes.each do |code| 
      country = Country.find_by_code3(code.downcase) 
      countries.append(country)
    end
    countries
  end

  def flag
    "#{ code2.downcase }.png"
  end
end

