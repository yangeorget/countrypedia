require 'open-uri'
require 'webrick/httputils'

class Util::Web
  def self.get(url)
    Rails.logger.debug("get: #{ url }") 
    begin
      Rails.cache.fetch(url, :expires_in => 1.day) do
        open(url).read
      end
    rescue Exception => e
      Rails.logger.debug("could not get: #{ url }") 
      nil
    end
  end
end
