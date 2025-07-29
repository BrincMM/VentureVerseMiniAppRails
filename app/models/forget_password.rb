class ForgetPassword < ApplicationRecord
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :code, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 100000, less_than_or_equal_to: 999999 }

  # Scopes
  scope :for_email, ->(email) { where(email: email) }
  scope :with_code, ->(code) { where(code: code) }
  scope :recent, -> { order(created_at: :desc) }

  # 生成6位数字验证码
  def self.generate_code
    rand(100000..999999)
  end

  # 验证码是否过期（默认10分钟）
  def expired?(expiry_minutes = 10)
    created_at < expiry_minutes.minutes.ago
  end

  # 验证码是否有效
  def valid_code?(input_code)
    code.to_i == input_code.to_i && !expired?
  end
end 