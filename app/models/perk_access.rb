class PerkAccess < ApplicationRecord
  belongs_to :user
  belongs_to :perk

  validates :user_id, uniqueness: { scope: :perk_id, message: 'already has access to this perk' }
end
