class Util::Restcountries
  def self.country_by_code2(code2)
    url = "https://restcountries.eu/rest/v1/alpha?codes=#{ code2 }"
    begin
      Rails.cache.fetch(url, :expires_in => 1.day) do
        HTTParty.get(url)[0]
      end
    rescue Exception
      { 
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
        'timezones' => [nil],
        'topLevelDomain' => [nil]
      }
    end
  end
end
