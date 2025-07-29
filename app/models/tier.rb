class Tier < ApplicationRecord
  has_many :users, dependent: :restrict_with_error

  validates :tier_name, presence: true, uniqueness: true
  validates :stripe_price_id, presence: true, uniqueness: true
  validates :active, inclusion: { in: [true, false] }

  scope :active, -> { where(active: true) }
end 