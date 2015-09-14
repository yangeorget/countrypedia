class AddCapitalToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :capital, :string
  end
end
