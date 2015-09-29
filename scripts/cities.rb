Country.all.each do |country|
  country.geonames_largestcities.each do |city|
    tokens = city.split('/')
    puts "Country.find_by_name('#{ country.name }').cities.create(geonames_id: '#{ tokens[3] }' name: '#{ tokens[4].split('.')[0] }')" 
  end
end
