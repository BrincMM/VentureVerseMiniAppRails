class CreditTopup < ApplicationRecord
  belongs_to :user

  validates :timestamp, presence: true
  validates :credits, presence: true, numericality: { greater_than: 0 }
end 
