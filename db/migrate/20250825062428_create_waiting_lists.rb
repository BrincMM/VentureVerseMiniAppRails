class CreateWaitingLists < ActiveRecord::Migration[8.0]
  def change
    create_table :waiting_lists do |t|
      t.string :email

      t.timestamps
    end
    add_index :waiting_lists, :email, unique: true
  end
end
