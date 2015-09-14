class AddCode3ToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :code3, :string
  end
end
