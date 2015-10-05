require 'httparty'

class Util::Openexchangerates
  def self.rates
    url = "https://openexchangerates.org/api/latest.json?app_id=780adb29f52c4bbc92cadac35bace194"
    begin
      Rails.cache.fetch(url, :expires_in => 1.day) do
        json = HTTParty.get(url)
        json['rates']
      end
    rescue Exception
      nil
    end
  end
end
