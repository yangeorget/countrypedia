Country.all.each do |country|
  country.geonames_largestcities.each do |city|
    city_name = I18n.transliterate(city.to_s).downcase.gsub(/[ ']/, '-')   
    puts "Country.find_by_name('#{ country.name }').cities.create(name: '#{ city_name }')" 
  end
end
