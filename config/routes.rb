Rails.application.routes.draw do

  # Routes for main resources
  resources :items
  resources :purchases
  resources :item_prices
  resources :orders
  resources :order_items
  resources :schools
  resources :users
  resources :sessions

  # Authentication routes
  get 'user/edit' => 'users#edit', as: :edit_current_user
  get 'signup' => 'users#new', as: :signup

  get 'logout' => 'sessions#destroy', as: :logout
  get 'login' => 'sessions#new', as: :login

  # Semi-static page routes
  get 'home' => 'home#home', as: :home
  get 'about' => 'home#about', as: :about
  get 'contact' => 'home#contact', as: :contact
  get 'privacy' => 'home#privacy', as: :privacy

  # Cart Functionalities
  get 'cart' => 'cart#cart', as: :cart
  get 'add_to_cart' => 'cart#add', as: :add_to_cart
  get 'remove_from_cart' => 'cart#remove', as: :remove_from_cart
  get 'finalize_purchase' => 'cart#finalize', as: :finalize_purchase
  post 'create_card' => 'credit_card#create', as: :create_card
  get 'delete_card' => 'credit_card#destroy', as: :delete_card
  get 'remove_school' => 'cart#remove_school', as: :remove_school

  get 'ship_item' => 'orders#ship', as: :ship_item

  # Route Error Handling
  get '*path', to: 'errors#not_found'

  # Set the root url
  root to: 'home#home'

end
