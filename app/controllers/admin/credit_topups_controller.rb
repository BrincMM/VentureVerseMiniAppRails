class Admin::CreditTopupsController < ApplicationController
  before_action :authenticate_admin!
  layout "admin"

  def index
    scope = credit_topup_scope
    @credit_topups = scope.page(params[:page]).per(20)
    if @user.present?
      @credit_topups_count = scope.count
      @credit_topups_total = scope.sum(:credits)
    end
  end

  private

  def credit_topup_scope
    if params[:user_id].present?
      @user = User.find(params[:user_id])
      @user.credit_topups.order(timestamp: :desc)
    else
      CreditTopup.includes(:user).order(timestamp: :desc)
    end
  end
end

