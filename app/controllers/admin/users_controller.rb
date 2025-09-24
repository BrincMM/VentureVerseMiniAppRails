class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  layout "admin"
  before_action :set_user, only: [:show, :credit_topups, :credit_spents]

  def index
    @users = User.order(created_at: :desc).page(params[:page]).per(20)
  end

  def show
    credit_topup_scope = @user.credit_topups
    credit_spent_scope = @user.credit_spents

    @credit_topups = credit_topup_scope.order(timestamp: :desc).limit(10)
    @credit_topups_count = credit_topup_scope.count
    @credit_topups_total = credit_topup_scope.sum(:credits)

    @credit_spents = credit_spent_scope.order(timestamp: :desc).limit(10)
    @credit_spents_count = credit_spent_scope.count
    @credit_spents_total = credit_spent_scope.sum(:credits)
    @credit_spents_total_cost = credit_spent_scope.sum(:cost_in_usd)

    @tier = @user.tier
    @credit_info = {
      monthly_credit_balance: @user.monthly_credit_balance,
      topup_credit_balance: @user.topup_credit_balance
    }
  end

  def credit_topups
    redirect_to admin_credit_topups_path(user_id: @user.id)
  end

  def credit_spents
    redirect_to admin_credit_spents_path(user_id: @user.id)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end

