class Language < ActiveRecord::Base
  extend FriendlyId
  friendly_id :code
  has_many :countries

  def self.url_or_text_from_code(code)
    lang = Language.find_by_code(code)
    if lang
      "<a href='#{ Rails.application.routes.url_helpers.language_path(lang) }'>#{ code }</a>"
    else
      code
    end
  end
end
