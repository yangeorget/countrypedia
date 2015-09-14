class AddRegionCodeToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :region_code, :string
  end
end
