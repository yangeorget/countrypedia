class AddGeonamesIdToCities < ActiveRecord::Migration
  def change
    add_column :cities, :geonames_id, :string
  end
end
