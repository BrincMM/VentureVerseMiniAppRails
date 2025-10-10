class AddForeignKeyToApps < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :apps, :developers, column: :developer_id, on_delete: :nullify
  end
end
