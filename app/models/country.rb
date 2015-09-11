require 'nokogiri'
require 'open-uri'
require 'html_truncator'

class Country < ActiveRecord::Base
  belongs_to :language

  def wikipedia_site
    "https://#{ language.code }.wikipedia.org"
  end

  def wikipedia_url
    "#{ wikipedia_site }/wiki/#{ name}"
  end

  def wikipedia_doc
    Nokogiri::HTML(open(wikipedia_url))
  end

  def wikipedia_info
    html = wikipedia_doc.xpath("//*[@id='mw-content-text']/p").to_s
    html = HTML_Truncator.truncate(html, 200)
    link_sanitizer = Rails::Html::LinkSanitizer.new
    link_sanitizer.sanitize(html)
  end
end

