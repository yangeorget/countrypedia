class CreateWebRedirects < ActiveRecord::Migration
  def change
    create_table :web_redirects do |t|
      t.string :from
      t.string :to

      t.timestamps null: false
    end
    add_index :web_redirects, :from
  end
end
