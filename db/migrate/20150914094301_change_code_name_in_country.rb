class ChangeCodeNameInCountry < ActiveRecord::Migration
  def change
    rename_column :countries, :code, :code2
  end
end
