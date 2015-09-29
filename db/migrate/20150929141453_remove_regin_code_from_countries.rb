class RemoveReginCodeFromCountries < ActiveRecord::Migration
  def change
    remove_column :countries, :region_code, :string
  end
end
