require 'httparty'

class City < ActiveRecord::Base
  extend FriendlyId
  belongs_to :country
  friendly_id :name

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
end

