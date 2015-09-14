class AddWoeidToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :woeid, :string
  end
end
