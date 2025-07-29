class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :google_id
      t.string :first_name, null: false
      t.string :last_name
      t.string :country
      t.boolean :age_consent, default: false
      t.string :password
      t.string :avatar
      t.string :nick_name
      t.string :linkedIn
      t.string :twitter
      t.decimal :monthly_credit_balance, precision: 10, scale: 2, default: 0
      t.integer :tier, default: 0
      t.decimal :top_up_credit_balance, precision: 10, scale: 2, default: 0

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :google_id, unique: true
    add_index :users, :nick_name, unique: true
  end
end
