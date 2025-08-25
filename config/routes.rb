Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  namespace :api do
    get 'health', to: 'health#index'

    namespace :v1 do
      resources :apps, only: [:index] do
        collection do
          post 'add_access'
          delete 'remove_access'
        end
      end

      resources :app_activities, only: [:index, :create]
      resources :log_in_histories, only: [:index, :create]

      resources :credit_spents, only: [:create] do
        collection do
          post 'estimate'
        end
      end

      resources :credit_topups, only: [:create]
      resources :tiers, only: [:index]
      
      # Stripe subscriptions
      post 'stripe/webhooks', to: 'stripe_webhooks#handle'

      namespace :users do
        post 'email_signup', to: 'registrations#email_signup'
        post 'google_signup', to: 'registrations#google_signup'
        post 'verify_password', to: 'sessions#verify_password'
        patch 'update_password', to: 'sessions#update_password'
        get 'profile', to: 'profiles#show'
        patch ':user_id/profile', to: 'profiles#update'
        get 'profile/credit_info', to: 'profiles#credit_info'
        post 'forget_password', to: 'forget_passwords#create'
        post 'verify_forget_password', to: 'forget_passwords#verify'
        post 'change_plan', to: 'change_plan#create'
        post 'cancel_plan', to: 'cancel_plan#create'
      end
    end
  end

  # Subscription page routes (outside API namespace)
  get 'subscriptions', to: 'subscriptions#index'
  post 'subscriptions/:plan', to: 'subscriptions#create', as: 'create_subscription'
  
  # Stripe customer management
  get 'stripe_customers', to: 'stripe_customers#index'
  post 'stripe_customers/search', to: 'stripe_customers#search'
  post 'stripe_customers/sync/:customer_id', to: 'stripe_customers#sync', as: 'sync_stripe_customer'

  # Defines the root path route ("/")
  # root "posts#index"
end