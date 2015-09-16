%w(en fr).each do |locale|
  SitemapGenerator::Sitemap.default_host = "http://#{ locale }.countrypedia.xyz"
  SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/#{ locale }"
  SitemapGenerator::Sitemap.create do
    Country.find_each do |country|
      add country_path(country)
    end
  end
end
