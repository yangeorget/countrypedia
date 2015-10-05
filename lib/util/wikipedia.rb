class Util::Wikipedia
  def self.paragraphs(page, xpath, nb)
    nodes = Nokogiri::HTML(page).xpath(xpath).first(nb) 
    paragraphs = []
    nodes.each do |node|
      if node
        paragraphs.append(Rails::Html::FullSanitizer.new.sanitize(node.to_s))
      end
    end
    paragraphs
  end
end
