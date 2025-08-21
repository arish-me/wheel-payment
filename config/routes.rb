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

  # Admin routes
  namespace :admin do
    get "dashboard/index"
    get "dashboard", to: "dashboard#index"
    resources :disputes, only: [:index, :show, :update]
    resources :transactions, only: [:index, :show]
  end
end
