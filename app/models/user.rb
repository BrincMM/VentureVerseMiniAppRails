class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable

  # Override Devise's password validation for Google sign-up
  def password_required?
    super && google_id.blank?
  end
  belongs_to :tier, optional: true
  has_many :user_roles, dependent: :destroy
  has_many :app_activities, dependent: :destroy
  has_many :app_accesses, dependent: :destroy
  has_many :accessible_apps, through: :app_accesses, source: :app
  has_many :log_in_histories, dependent: :destroy
  has_one :stripe_info, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, :last_name, :age_consent, presence: true
  validates :nick_name, uniqueness: true, allow_nil: true
  validates :google_id, uniqueness: true, allow_nil: true
  validates :monthly_credit_balance, :top_up_credit_balance, numericality: { greater_than_or_equal_to: 0 }
  validates :linkedIn, :twitter, :avatar, url: true, allow_blank: true

  before_validation :set_random_password_for_google_user, if: -> { google_id.present? && encrypted_password.blank? }

  # Helper methods to check roles
  def founder?
    user_roles.exists?(role: :founder)
  end

  def mentor?
    user_roles.exists?(role: :mentor)
  end

  def investor?
    user_roles.exists?(role: :investor)
  end

  def add_role(role)
    user_roles.create(role: role) unless user_roles.exists?(role: role)
  end

  def remove_role(role)
    user_roles.where(role: role).destroy_all
  end

  def current_tier_name
    tier&.tier_name || 'Free'
  end

  def has_access_to?(app)
    app_accesses.exists?(app: app)
  end

  def grant_access_to(app)
    app_accesses.create!(app: app)
  end

  def revoke_access_to(app)
    app_accesses.find_by(app: app)&.destroy
  end

  def record_activity(app, activity_type, meta = nil)
    app_activities.create!(
      app: app,
      activity_type: activity_type,
      app_meta: meta,
      timestamp: Time.current
    )
  end

  def active_subscription?
    stripe_info&.active?
  end

  def stripe_customer?
    stripe_info.present?
  end

  def days_until_next_billing
    stripe_info&.days_until_next_billing
  end

  private

  def set_random_password_for_google_user
    self.password = SecureRandom.hex(20) if google_id.present? && encrypted_password.blank?
  end
end 