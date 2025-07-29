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

  # Scopes
  scope :by_app, ->(app_id) { where(app_id: app_id) }
  scope :by_user, ->(user_id) { where(user_id: user_id) }
  scope :by_type, ->(type) { where(activity_type: type) }
  scope :recent, -> { order(timestamp: :desc) }
  scope :in_date_range, ->(start_date, end_date) { 
    where(timestamp: start_date.beginning_of_day..end_date.end_of_day) 
  }
end 