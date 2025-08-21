Rails.application.routes.draw do
  # Devise routes
  devise_for :users

  # Home page
  root "home#index"

  # Dashboard (requires authentication)
  get "dashboard", to: "dashboard#index", as: :dashboard

  # Projects
  resources :projects do
    resources :milestones, only: [:create, :update, :destroy] do
      member do
        post :fund
        post :complete
        post :release
        post :refund
      end
      resources :disputes, only: [:create, :update]
    end
  end

  # Reviews
  resources :reviews, only: [:create, :update]

  # Payment routes
  get 'payments/create_checkout_session', to: 'payments#create_checkout_session'
  get 'payments/success', to: 'payments#success'
  get 'payments/cancel', to: 'payments#cancel'

  # Developer onboarding
  get 'developer_onboarding/stripe_connect', to: 'developer_onboarding#stripe_connect'

  # Webhooks
  post 'webhooks/stripe', to: 'webhooks#stripe'
  get 'webhooks/test/:milestone_id', to: 'webhooks#test_webhook', as: :test_webhook

  # Admin routes
  namespace :admin do
    get "dashboard/index"
    get "dashboard", to: "dashboard#index"
    resources :disputes, only: [:index, :show, :update]
    resources :transactions, only: [:index, :show]
  end
end
