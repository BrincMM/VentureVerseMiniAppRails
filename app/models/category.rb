class Category < ApplicationRecord
  has_many :apps, dependent: :nullify
  has_many :perks, dependent: :nullify

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :ordered_by_name, -> { order(:name, :id) }
end
