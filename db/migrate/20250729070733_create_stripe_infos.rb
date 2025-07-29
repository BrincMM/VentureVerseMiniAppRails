class CreateStripeInfos < ActiveRecord::Migration[8.0]
  def change
    create_table :stripe_infos do |t|
      t.references :user, null: false, foreign_key: true
      t.string :stripe_customer_id, null: false
      t.string :subscription_id
      t.string :subscription_status
      t.datetime :next_subscription_time

      t.timestamps
    end

    add_index :stripe_infos, :stripe_customer_id, unique: true
    add_index :stripe_infos, :subscription_id
    add_index :stripe_infos, :subscription_status
  end
end
