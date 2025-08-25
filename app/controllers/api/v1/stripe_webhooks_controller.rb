# frozen_string_literal: true

module Api
  module V1
    class StripeWebhooksController < ApiController
      
      def handle
        payload = request.body.read
        sig_header = request.env['HTTP_STRIPE_SIGNATURE']
        
        begin
          # Set Stripe API key
          Stripe.api_key = Rails.application.credentials.strip[:secret_key]
          
          # Verify webhook signature (you'll need to add webhook endpoint secret to credentials)
          # For now, we'll skip signature verification in development
          if Rails.env.development?
            event = Stripe::Event.construct_from(JSON.parse(payload))
          else
            # In production, you should verify the webhook signature
            # endpoint_secret = Rails.application.credentials.strip[:webhook_secret]
            # event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
            event = Stripe::Event.construct_from(JSON.parse(payload))
          end
          
          # Handle the event
          case event.type
          when 'customer.subscription.created'
            handle_subscription_created(event.data.object)
          when 'customer.subscription.updated'
            handle_subscription_updated(event.data.object)
          when 'invoice.payment_succeeded'
            handle_payment_succeeded(event.data.object)
          when 'customer.subscription.deleted'
            handle_subscription_deleted(event.data.object)
          else
            Rails.logger.info "Unhandled Stripe webhook event type: #{event.type}"
          end
          
          render json: { status: 'success' }, status: :ok
          
        rescue JSON::ParserError => e
          Rails.logger.error "Invalid JSON in Stripe webhook: #{e.message}"
          render json: { error: 'Invalid JSON' }, status: :bad_request
        rescue Stripe::SignatureVerificationError => e
          Rails.logger.error "Invalid Stripe signature: #{e.message}"
          render json: { error: 'Invalid signature' }, status: :bad_request
        rescue => e
          Rails.logger.error "Stripe webhook error: #{e.message}"
          render json: { error: 'Webhook error' }, status: :internal_server_error
        end
      end
      
      private
      
      def handle_subscription_created(subscription)
        Rails.logger.info "Processing subscription created: #{subscription.id}"
        update_user_subscription_info(subscription)
      end
      
      def handle_subscription_updated(subscription)
        Rails.logger.info "Processing subscription updated: #{subscription.id}"
        update_user_subscription_info(subscription)
      end
      
      def handle_payment_succeeded(invoice)
        Rails.logger.info "Processing payment succeeded for invoice: #{invoice.id}"
        
        # Get subscription from invoice
        if invoice.subscription
          subscription = Stripe::Subscription.retrieve(invoice.subscription)
          update_user_subscription_info(subscription)
        end
      end
      
      def handle_subscription_deleted(subscription)
        Rails.logger.info "Processing subscription deleted: #{subscription.id}"
        
        # Find user by stripe customer ID
        stripe_info = StripeInfo.find_by(stripe_customer_id: subscription.customer)
        if stripe_info
          stripe_info.update!(
            subscription_status: 'canceled',
            next_subscription_time: nil
          )
          Rails.logger.info "Cancelled subscription for user #{stripe_info.user.email}"
        end
      end
      
      def update_user_subscription_info(subscription)
        # Find user by stripe customer ID
        stripe_info = StripeInfo.find_by(stripe_customer_id: subscription.customer)
        
        unless stripe_info
          Rails.logger.error "No StripeInfo found for customer: #{subscription.customer}"
          return
        end
        
        # Update subscription information
        stripe_info.update!(
          subscription_id: subscription.id,
          subscription_status: subscription.status,
          next_subscription_time: Time.at(subscription.current_period_end)
        )
        
        # Update user's tier based on the subscription
        update_user_tier(stripe_info.user, subscription)
        
        Rails.logger.info "Updated subscription info for user #{stripe_info.user.email}: " \
                         "status=#{subscription.status}, next_billing=#{Time.at(subscription.current_period_end)}"
      end
      
      def update_user_tier(user, subscription)
        # Get the price ID from the subscription
        price_id = subscription.items.data.first&.price&.id
        
        if price_id
          # Find tier by stripe_price_id
          tier = Tier.find_by(stripe_price_id: price_id)
          if tier
            user.update!(tier: tier)
            Rails.logger.info "Updated user #{user.email} to tier: #{tier.name} (price_id: #{price_id})"
          else
            Rails.logger.warn "No tier found for price_id: #{price_id}"
          end
        else
          Rails.logger.warn "No price_id found in subscription: #{subscription.id}"
        end
      end
    end
  end
end
