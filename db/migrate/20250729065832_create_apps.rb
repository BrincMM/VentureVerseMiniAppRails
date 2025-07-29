class CreateApps < ActiveRecord::Migration[8.0]
  def change
    create_table :apps do |t|
      t.string :app_name, null: false
      t.text :description
      t.string :category
      t.string :sector
      t.string :link

      t.timestamps
    end

    add_index :apps, :app_name, unique: true
    add_index :apps, :category
    add_index :apps, :sector
  end
end
