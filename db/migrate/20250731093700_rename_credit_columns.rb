class RenameCreditColumns < ActiveRecord::Migration[8.0]
  def change
    rename_column :credit_spents, :credit_spent, :credits
    rename_column :credit_topups, :credit_topup, :credits
  end
end