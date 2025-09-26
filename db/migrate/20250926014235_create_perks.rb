class CreatePerks < ActiveRecord::Migration[8.0]
  def change
    create_table :perks do |t|
      t.string :partner_name, null: false
      t.string :category
      t.string :sector
      t.string :company_website, null: false
      t.string :contact_email, null: false
      t.string :contact, null: false

      t.timestamps
    end
  end
end
