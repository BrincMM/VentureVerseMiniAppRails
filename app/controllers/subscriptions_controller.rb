# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  def index
    @users = User.limit(20).order(:first_name, :last_name)
    @selected_user_id = params[:user_id]
    @user = @selected_user_id.present? ? User.find_by(id: @selected_user_id) : nil
    @available_plans = StripeCheckoutService.available_plans
    
    # Handle success/cancel messages
    if params[:success] == 'true'
      flash.now[:notice] = 'Payment successful! Your subscription will be processed shortly.'
    elsif params[:cancelled] == 'true'
      flash.now[:alert] = 'Payment was cancelled. You can try again anytime.'
    end
  end

  def create
    plan = params[:plan]
    user_id = params[:user_id]
    
    @user = User.find_by(id: user_id)
    
    unless @user
      redirect_to subscriptions_path, alert: 'User not found'
      return
    end

    unless StripeCheckoutService.available_plans.include?(plan)
      redirect_to subscriptions_path, alert: 'Invalid plan selected'
      return
    end

    begin
      checkout_service = StripeCheckoutService.new(@user, plan)
      session = checkout_service.create_checkout_session
      
      # Redirect to Stripe Checkout
      redirect_to session.url, allow_other_host: true
    rescue => e
      Rails.logger.error "Error creating checkout session: #{e.message}"
      redirect_to subscriptions_path, alert: 'Failed to create checkout session'
    end
  end
end
