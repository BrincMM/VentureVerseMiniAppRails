class RemoveSecretFromDevelopers < ActiveRecord::Migration[8.0]
  def change
    remove_column :developers, :secret, :string
  end
end
