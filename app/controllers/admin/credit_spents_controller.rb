class Admin::CreditSpentsController < ApplicationController
  before_action :authenticate_admin!
  layout "admin"

  def index
    scope = credit_spent_scope
    @credit_spents = scope.page(params[:page]).per(20)
    if @user.present?
      @credit_spents_count = scope.count
      @credit_spents_total = scope.sum(:credits)
      @credit_spents_total_cost = scope.sum(:cost_in_usd)
    end
  end

  private

  def credit_spent_scope
    if params[:user_id].present?
      @user = User.find(params[:user_id])
      @user.credit_spents.order(timestamp: :desc)
    else
      CreditSpent.includes(:user).order(timestamp: :desc)
    end
  end
end

