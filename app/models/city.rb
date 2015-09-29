class City < ActiveRecord::Base
  extend FriendlyId
  belongs_to :country
  friendly_id :name
end
