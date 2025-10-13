class RemoveUniqueIndexFromDevelopersGithub < ActiveRecord::Migration[8.0]
  def change
    # Remove the unique index on github
    remove_index :developers, :github, unique: true
    
    # Add a non-unique index for performance (optional, but recommended)
    add_index :developers, :github
  end
end
