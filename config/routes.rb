Rails.application.routes.draw do
  devise_for :developers
  devise_for :admins
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
      resources :apps, only: [:index, :create, :update, :destroy] do
        collection do
          get 'filters'
          post 'add_access'
          delete 'remove_access'
        end
      end

      resources :perks, only: [:index, :create, :update, :destroy] do
        collection do
          get 'filters'
        end
      end
      resources :perk_accesses, only: [:create, :destroy]
      resources :categories, only: [:index, :create, :update, :destroy]
      resources :sectors, only: [:index, :create, :update, :destroy]

      resources :app_activities, only: [:index, :create]
      resources :log_in_histories, only: [:index, :create]

      resources :credit_spents, only: [:create] do
        collection do
          post 'estimate'
        end
      end

      resources :credit_topups, only: [:create]
      resources :tiers, only: [:index]
      resources :waiting_lists, only: [:create]
      
      resources :users, only: [] do
        resources :perks, only: [:index], module: :users
      end

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

      # Developer resources (nested for RESTful access by ID)
      resources :developers, only: [], path: 'developers', module: 'developers' do
        resources :apps, only: [:index], controller: 'apps'
      end

      namespace :developers do
        post 'email_signup', to: 'registrations#email_signup'
        post 'verify_password', to: 'sessions#verify_password'
        patch 'update_password', to: 'sessions#update_password'
        post 'forget_password', to: 'forget_passwords#create'
        post 'verify_forget_password', to: 'forget_passwords#verify'
        get 'profile', to: 'profiles#show'
        patch ':developer_id/profile', to: 'profiles#update'
        
        # Apps management
        resources :apps, only: [:show, :create, :update, :destroy] do
          resources :api_keys, only: [] do
            collection do
              post :rotate
            end
          end
        end
      end

      # API Keys validation (public endpoint for SDK)
      resources :api_keys, only: [] do
        collection do
          post :validate
        end
      end
    end
  end

  namespace :admin do
    resources :dashboard, only: [:index]
    resources :credit_topups, only: [:index]
    resources :credit_spents, only: [:index]
    resources :users, only: [:index, :show] do
      member do
        get :credit_topups
        get :credit_spents
      end
    end
    resources :waiting_list, only: [:index, :show] do
      post :sync_beehiiv, on: :member
      post :resend_welcome_email, on: :member
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