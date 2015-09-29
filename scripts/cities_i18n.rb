Country.all.each do |country|
  hash = country.geonames_largestcities
  country.cities.each do |city|
    puts "#{ city.name }: \"#{ hash[city.geonames_id] }\"" 
  end
end
