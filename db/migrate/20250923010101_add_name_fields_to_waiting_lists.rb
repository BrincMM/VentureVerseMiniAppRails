class AddNameFieldsToWaitingLists < ActiveRecord::Migration[8.0]
  def change
    add_column :waiting_lists, :first_name, :string
    add_column :waiting_lists, :last_name, :string
    add_column :waiting_lists, :name, :string
  end
end


