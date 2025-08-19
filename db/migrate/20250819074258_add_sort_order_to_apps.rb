class AddSortOrderToApps < ActiveRecord::Migration[8.0]
  def change
    add_column :apps, :sort_order, :integer, default: 0
    add_index :apps, :sort_order
  end
end
