class UserRole < ApplicationRecord
  belongs_to :user

  # Rails 8 enum syntax
  enum :role, { founder: 0, mentor: 1, investor: 2 }

  validates :role, presence: true
  validates :user_id, uniqueness: { scope: :role, message: "already has this role" }
end 