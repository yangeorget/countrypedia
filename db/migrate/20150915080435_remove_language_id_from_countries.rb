class RemoveLanguageIdFromCountries < ActiveRecord::Migration
  def change
    remove_column :countries, :language_id, :int
  end
end
