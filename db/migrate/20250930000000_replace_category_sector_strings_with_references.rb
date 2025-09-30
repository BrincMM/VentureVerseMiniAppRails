class ReplaceCategorySectorStringsWithReferences < ActiveRecord::Migration[8.0]
  class MigrationApp < ActiveRecord::Base
    self.table_name = 'apps'
  end

  class MigrationPerk < ActiveRecord::Base
    self.table_name = 'perks'
  end

  class MigrationCategory < ActiveRecord::Base
    self.table_name = 'categories'
  end

  class MigrationSector < ActiveRecord::Base
    self.table_name = 'sectors'
  end

  def up
    add_reference :apps, :category, foreign_key: true, index: true
    add_reference :apps, :sector, foreign_key: true, index: true
    add_reference :perks, :category, foreign_key: true, index: true
    add_reference :perks, :sector, foreign_key: true, index: true

    MigrationApp.reset_column_information
    MigrationPerk.reset_column_information
    MigrationCategory.reset_column_information
    MigrationSector.reset_column_information

    MigrationApp.find_each do |app|
      category_name = app[:category]
      sector_name = app[:sector]

      if category_name.present?
        category = MigrationCategory.find_or_create_by!(name: category_name)
        app.update_columns(category_id: category.id)
      end

      if sector_name.present?
        sector = MigrationSector.find_or_create_by!(name: sector_name)
        app.update_columns(sector_id: sector.id)
      end
    end

    MigrationPerk.find_each do |perk|
      category_name = perk[:category]
      sector_name = perk[:sector]

      if category_name.present?
        category = MigrationCategory.find_or_create_by!(name: category_name)
        perk.update_columns(category_id: category.id)
      end

      if sector_name.present?
        sector = MigrationSector.find_or_create_by!(name: sector_name)
        perk.update_columns(sector_id: sector.id)
      end
    end

    remove_column :apps, :category, :string
    remove_column :apps, :sector, :string
    remove_column :perks, :category, :string
    remove_column :perks, :sector, :string
  end

  def down
    add_column :apps, :category, :string
    add_column :apps, :sector, :string
    add_column :perks, :category, :string
    add_column :perks, :sector, :string

    MigrationApp.reset_column_information
    MigrationPerk.reset_column_information
    MigrationCategory.reset_column_information
    MigrationSector.reset_column_information

    MigrationApp.find_each do |app|
      if app[:category_id].present?
        category = MigrationCategory.find_by(id: app[:category_id])
        app.update_columns(category: category&.name)
      end

      if app[:sector_id].present?
        sector = MigrationSector.find_by(id: app[:sector_id])
        app.update_columns(sector: sector&.name)
      end
    end

    MigrationPerk.find_each do |perk|
      if perk[:category_id].present?
        category = MigrationCategory.find_by(id: perk[:category_id])
        perk.update_columns(category: category&.name)
      end

      if perk[:sector_id].present?
        sector = MigrationSector.find_by(id: perk[:sector_id])
        perk.update_columns(sector: sector&.name)
      end
    end

    remove_reference :apps, :category, foreign_key: true
    remove_reference :apps, :sector, foreign_key: true
    remove_reference :perks, :category, foreign_key: true
    remove_reference :perks, :sector, foreign_key: true
  end
end

