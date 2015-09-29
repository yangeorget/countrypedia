class RemoveCapitalFromCountries < ActiveRecord::Migration
  def change
    remove_column :countries, :capital, :string
  end
end
