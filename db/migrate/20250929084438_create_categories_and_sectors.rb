class CreateCategoriesAndSectors < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :categories, :name, unique: true

    create_table :sectors do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :sectors, :name, unique: true
  end
end
