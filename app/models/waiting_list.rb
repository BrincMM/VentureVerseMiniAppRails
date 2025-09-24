class WaitingList < ApplicationRecord
  # Rails 8 enum syntax
  enum :subscribe_type, { email: 0, google: 1 }

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :subscribe_type, presence: true

  before_validation :normalize_and_split_name

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :by_email, ->(email) { where(email: email) }
  scope :by_subscribe_type, ->(type) { where(subscribe_type: type) }

  private

  def normalize_and_split_name
    return if name.blank?

    cleaned_name = name.to_s.squish
    self.name = cleaned_name

    # Do not override explicitly provided first_name/last_name
    tokens = cleaned_name.split(' ')

    if tokens.length == 1
      self.first_name = first_name.presence || tokens.first
      self.last_name = last_name.presence
    else
      self.last_name = last_name.presence || tokens.pop
      self.first_name = first_name.presence || tokens.join(' ')
    end
  end
end
