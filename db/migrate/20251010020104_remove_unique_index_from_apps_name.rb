class RemoveUniqueIndexFromAppsName < ActiveRecord::Migration[8.0]
  def change
    remove_index :apps, name: "index_apps_on_name"
    add_index :apps, :name
  end
end
