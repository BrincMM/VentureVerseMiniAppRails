# frozen_string_literal: true

class DeviseCreateDevelopers < ActiveRecord::Migration[8.0]
  def change
    create_table :developers do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Custom fields
      t.string :name
      t.string :github
      t.string :secret

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Custom enum fields
      t.integer :status, default: 0, null: false
      t.integer :role, default: 0, null: false

      t.timestamps null: false
    end

    add_index :developers, :email, unique: true
    add_index :developers, :github, unique: true
    add_index :developers, :confirmation_token, unique: true
  end
end
