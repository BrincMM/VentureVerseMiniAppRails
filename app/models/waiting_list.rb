class WaitingList < ApplicationRecord
  # Rails 8 enum syntax
  enum :subscribe_type, { email: 0, google: 1 }

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :subscribe_type, presence: true

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :by_email, ->(email) { where(email: email) }
  scope :by_subscribe_type, ->(type) { where(subscribe_type: type) }
end
