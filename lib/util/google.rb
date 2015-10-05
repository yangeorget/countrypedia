require 'logger'
require 'httparty'

class Util::Google
  KEY = "AIzaSyCRckkdFPzcbgqL2-PAhmo6aEDNU8hITQM"

  def self.staticmaps_url(type, width, height, query)
    params = {
      :type => type,
      :size => "#{ width }x#{ height }",
      :center => query,
      :language => I18n.locale,
      :key => KEY,
      :format => "jpg"
    }
    url = URI.escape("https://maps.googleapis.com/maps/api/staticmap?#{ params.to_query }")
    Rails.logger.debug("Google Static Maps URL=#{ url }")
    url
  end

  def self.maps_url(zoom, latitude, longitude)
    params = {
      :zoom => "#{ zoom }",
      :center => "#{ latitude },#{ longitude }",
      :key => KEY
    }
    "https://www.google.com/maps/embed/v1/view?#{ params.to_query }"
  end

  def self.time(timestamp, latitude, longitude)
    params = {
      :key => KEY,
      :location => "#{ latitude },#{ longitude }",
      :timestamp => "#{ timestamp }",
      :language => "#{ I18n.locale }"
    }
    HTTParty.get("https://maps.googleapis.com/maps/api/timezone/json?#{ params.to_query }")
  end

  def self.images_search(nb, query)
    params = {
      :v => "1.0",
      :as_filetype => "jpg",
      :hl => "en",
      :imgsz => "large",
      :imgtype => "photo",
      :rsz => nb,
      :q => query
    }
    url = "https://ajax.googleapis.com/ajax/services/search/images?#{ params.to_query }"
    Rails.logger.debug("Google Images Search URL=#{ url }")
    begin
      Rails.cache.fetch(url, :expires_in => 1.day) do
        json = HTTParty.get(url, {format: :json})
        json['responseData']['results'].map { |result| result['unescapedUrl'] }
      end
    rescue Exception
      nil
    end
  end
end 
