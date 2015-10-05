class Util::Forecastio 
  def self.weather(latitude, longitude)
    ForecastIO.forecast(latitude, longitude, params: { lang: I18n.locale, units: 'si', exclude: "minutely,daily" })
  end

  def self.link(latitude, longitude) 
    "http://forecast.io/#/f/#{ latitude },#{ longitude }"
  end
end
