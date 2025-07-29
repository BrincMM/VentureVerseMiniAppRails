class CreditSpent < ApplicationRecord
  belongs_to :user

  # Rails 8 enum syntax
  enum :spend_type, {
    app_usage: 0,
    content_procurement: 1,
    perks_procurement: 2,
    nft_procurement: 3
  }

  validates :timestamp, presence: true
  validates :credit_spent, presence: true, numericality: { greater_than: 0 }
  validates :spend_type, presence: true
end 