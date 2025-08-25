class AddSubscribeTypeToWaitingLists < ActiveRecord::Migration[8.0]
  def change
    add_column :waiting_lists, :subscribe_type, :integer, null: false, default: 0
    add_index :waiting_lists, :subscribe_type
  end
end
