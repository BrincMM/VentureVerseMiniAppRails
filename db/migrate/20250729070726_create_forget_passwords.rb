class CreateForgetPasswords < ActiveRecord::Migration[8.0]
  def change
    create_table :forget_passwords do |t|
      t.string :email, null: false
      t.decimal :code, null: false, precision: 6, scale: 0

      t.timestamps
    end

    add_index :forget_passwords, :email
    add_index :forget_passwords, [:email, :code]
  end
end
