Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  devise_for :users, controllers: {
                       registrations: "users/registrations",
                     }
  root "rubits#index"
  get "profile", to: "users#profile", as: "profile"

  resources :users, only: [:new, :create]
  resources :rubits, only: [:index, :show, :create, :destroy] do
    post :mark_seen, on: :member
    resources :likes, only: [:create, :destroy]
  end
  resources :hashtags, only: [:show]
  resources :products, only: [:index]
  resources :cart_items, only: [:destroy]
  resources :orders, only: [:index, :show, :new, :create]

  # start Espago payment flow for specific order
  get "payments/start_payment/:order_id", to: "payments#start_payment", as: "start_payment"
  # handle redirect from Espago site after success
  get "payment_success", to: "payments#payment_success"
  # handle redirect from Espago site after failure
  get "payment_failure", to: "payments#payment_failure"

  get "cart", to: "carts#show", as: "cart"
  post "add_to_cart/:product_id", to: "cart_items#create", as: "add_to_cart"

  get "users/dev_login", to: "users/sessions#dev_login" if Rails.env.development?

  get "*unmatched_route", to: redirect("/")
end
