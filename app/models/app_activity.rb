class AppActivity < ApplicationRecord
  belongs_to :app
  belongs_to :user

  # Rails 8 enum syntax
  enum :activity_type, {
    app_usage: 0,
    content_procurement: 1,
    perks_procurement: 2,
    nft_procurement: 3
  }

  validates :activity_type, presence: true
  validates :timestamp, presence: true
  validate :validate_app_meta_format

  # Scopes
  scope :by_app, ->(app_id) { where(app_id: app_id) }
  scope :by_user, ->(user_id) { where(user_id: user_id) }
  scope :by_type, ->(type) { where(activity_type: type) }
  scope :recent, -> { order(timestamp: :desc) }
  scope :in_date_range, ->(start_date, end_date) { 
    where(timestamp: start_date..end_date) 
  }

  private

  def validate_app_meta_format
    return if app_meta.nil?
    
    begin
      JSON.parse(app_meta) if app_meta.present?
    rescue JSON::ParserError
      errors.add(:app_meta, 'must be valid JSON')
    end
  end
end