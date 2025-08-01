class CreditSpent < ApplicationRecord
  belongs_to :user

  # Rails 8 enum syntax
  enum :spend_type, {
    app_usage: 0,
    content_procurement: 1,
    perks_procurement: 2,
    nft_procurement: 3
  }

  validates :timestamp, presence: true
  validates :credits, presence: true, numericality: { greater_than: 0 }
  validates :spend_type, presence: true
  validates :cost_in_usd, presence: true, numericality: { greater_than: 0 }

  CREDIT_TO_USD_RATE = 0.01  # 1 credit = 0.01 USD
  COST_MARKUP_RATE = 1.7     # 70% markup (1 + 0.7)

  before_validation :set_credit_spent
  before_validation :set_timestamp, on: :create
  after_create :deduct_user_credits

  private

  def deduct_user_credits
    remaining_credits = credits
    original_monthly_balance = user.monthly_credit_balance
    
    # First try to deduct from monthly credits
    if original_monthly_balance > 0
      deducted_monthly = [original_monthly_balance, remaining_credits].min
      remaining_credits -= deducted_monthly
      user.monthly_credit_balance = original_monthly_balance - deducted_monthly
    end

    # If there are still remaining credits, try to deduct from topup credits
    if remaining_credits > 0 && user.topup_credit_balance > 0
      deducted_topup = [user.topup_credit_balance, remaining_credits].min
      remaining_credits -= deducted_topup
      user.topup_credit_balance -= deducted_topup
    end

    # If there are still remaining credits, make monthly_credit_balance negative
    if remaining_credits > 0
      user.monthly_credit_balance = (original_monthly_balance > 0 ? 0 : original_monthly_balance) - remaining_credits
    end

    user.save!
  end

  def set_credit_spent
    self.credits ||= self.class.calculate_credit_amount(cost_in_usd)
  end

  def set_timestamp
    self.timestamp ||= Time.current
  end

  # Calculate credit needed for a given cost
  # @param cost [Float] cost in USD
  # @return [Integer] number of credits needed
  def self.calculate_credit_amount(cost)
    (cost * COST_MARKUP_RATE / CREDIT_TO_USD_RATE).ceil
  end
end 