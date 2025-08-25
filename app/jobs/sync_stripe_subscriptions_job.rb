# frozen_string_literal: true

class SyncStripeSubscriptionsJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info "🔄 Starting Stripe subscription sync job..."
    
    # Get all users with stripe_customer_id
    users_with_stripe = User.joins(:stripe_info).where.not(stripe_infos: { stripe_customer_id: nil })
    
    Rails.logger.info "📊 Found #{users_with_stripe.count} users with Stripe customer IDs"
    
    if users_with_stripe.count == 0
      Rails.logger.info "✅ No users to sync"
      return
    end
    
    # Set Stripe API key
    Stripe.api_key = Rails.application.credentials.strip[:secret_key]
    
    sync_stats = {
      total: users_with_stripe.count,
      success: 0,
      failed: 0,
      errors: []
    }
    
    users_with_stripe.find_each do |user|
      begin
        Rails.logger.info "🔄 Syncing user: #{user.email} (customer: #{user.stripe_info.stripe_customer_id})"
        
        service = StripeSubscriptionService.new(user)
        result = service.sync_subscription_info
        
        if result
          sync_stats[:success] += 1
          Rails.logger.info "✅ Successfully synced #{user.email}"
        else
          sync_stats[:failed] += 1
          Rails.logger.warn "❌ Failed to sync #{user.email} - no active subscription"
        end
        
      rescue Stripe::StripeError => e
        sync_stats[:failed] += 1
        error_msg = "Stripe error for #{user.email}: #{e.message}"
        sync_stats[:errors] << error_msg
        Rails.logger.error "💥 #{error_msg}"
        
      rescue => e
        sync_stats[:failed] += 1
        error_msg = "General error for #{user.email}: #{e.message}"
        sync_stats[:errors] << error_msg
        Rails.logger.error "💥 #{error_msg}"
      end
      
      # Small delay to avoid hitting Stripe API limits
      sleep(0.5)
    end
    
    # Log final statistics
    Rails.logger.info "📊 Sync job completed:"
    Rails.logger.info "   Total users: #{sync_stats[:total]}"
    Rails.logger.info "   Successful: #{sync_stats[:success]}"
    Rails.logger.info "   Failed: #{sync_stats[:failed]}"
    
    if sync_stats[:errors].any?
      Rails.logger.error "❌ Errors encountered:"
      sync_stats[:errors].each { |error| Rails.logger.error "   - #{error}" }
    end
    
    Rails.logger.info "✅ Stripe subscription sync job finished"
  end
end
