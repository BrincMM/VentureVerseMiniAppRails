class AddCostToCreditSpents < ActiveRecord::Migration[8.0]
  def change
    add_column :credit_spents, :cost_in_usd, :decimal, precision: 10, scale: 2, null: false
  end
end