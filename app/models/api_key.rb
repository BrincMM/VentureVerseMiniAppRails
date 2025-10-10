class ApiKey < ApplicationRecord
  belongs_to :app

  # Rails 8 enum syntax
  enum :status, { active: 0, revoked: 1, expired: 2 }, default: :active

  # Validations
  validates :api_key, presence: true, uniqueness: true
  validates :app_id, presence: true
  validates :rate_limit_per_minute, numericality: { greater_than: 0 }, allow_nil: true
  validates :rate_limit_per_day, numericality: { greater_than: 0 }, allow_nil: true

  # Callbacks
  before_validation :generate_api_key, on: :create, if: -> { api_key.blank? }

  # Scopes
  scope :valid_keys, -> { where(status: :active).where('expires_at IS NULL OR expires_at > ?', Time.current) }

  # Helper methods
  def expired_by_date?
    expires_at.present? && expires_at < Time.current
  end

  def valid_for_use?
    active? && !expired_by_date?
  end

  def revoke!
    update!(status: :revoked)
  end

  def record_usage!
    update!(last_used_at: Time.current)
  end

  private

  def generate_api_key
    self.api_key = SecureRandom.hex(32)
  end
end
