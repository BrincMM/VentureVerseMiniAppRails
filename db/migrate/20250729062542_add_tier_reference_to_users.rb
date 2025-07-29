class AddTierReferenceToUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :tier, :integer
    add_reference :users, :tier, null: true, foreign_key: true
  end
end
