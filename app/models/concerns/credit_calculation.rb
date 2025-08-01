module CreditCalculation
  extend ActiveSupport::Concern

  # Calculate the ratio of remaining credits to total available credits
  # @return [Float] the ratio of remaining credits to total available credits
  def remaining_credit_ratio
    total_remaining_credit = monthly_credit_balance + topup_credit_balance
    total_available_credit = (tier&.monthly_credit || 0) + topup_credit_balance
    
    return 0.0 if total_available_credit.zero?
    
    (total_remaining_credit / total_available_credit).to_f
  end
end