class AppAccess < ApplicationRecord
  belongs_to :app
  belongs_to :user

  validates :user_id, uniqueness: { scope: :app_id, message: "already has access to this app" }

  # Scopes
  scope :by_app, ->(app_id) { where(app_id: app_id) }
  scope :by_user, ->(user_id) { where(user_id: user_id) }
end 