class WaitingList < ApplicationRecord
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :by_email, ->(email) { where(email: email) }
end
