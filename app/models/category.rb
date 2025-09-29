class Category < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :ordered_by_name, -> { order(:name, :id) }
end

