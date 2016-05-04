Rails.application.routes.draw do
  resources :roles
  resources :permissions
  resources :orders
  resources :carts
  resources :products
  resources :addresses

  get '/restaurants/:id/dishes', to: 'restaurants#dishes', as: :restaurant_dishes

  resources :restaurants
  devise_for :users,
             controllers: {sessions: 'users/sessions',
                           confirmations: 'users/confirmations',
                           unlocks: 'users/unlocks',
                           registrations: 'users/registrations',
                           passwords: 'users/passwords',
                           password_expired: 'users/password_expired'},
             path: '/',
             path_names: {sign_in: 'login',
                          sign_out: 'logout'}

  devise_scope :user do
    post '/sign_in/mobile', to: 'users/sessions#create_mobile_session', as: :create_mobile_session

    authenticated :user do
      root 'home#index', as: :authenticated_root

      # Shows all users.
      get '/users', to: 'users/registrations#index', as: :user_registrations

      # Create new users.
      get '/users/new', to: 'users/registrations#new_user', as: :new_user
      post '/users', to: 'users/registrations#create_user', as: :create_user

      # Edit page for a user profile.
      get '/users/edit', to: 'users/registrations#edit', as: :edit_profile

      # Edit page for all users.
      get '/users/:id/edit', to: 'users/registrations#edit_user', as: :edit_user
      match '/users/:id', to: 'users/registrations#update_user', as: :update_user, via: [:patch, :put]

      # Show page for a user.
      get '/users/:id', to: 'users/registrations#show', as: :user

      # Edit a user password.
      get '/users/:id/change_password', to: 'users/registrations#change_password', as: :change_password
      match 'save_password/:id', to: 'users/registrations#save_password', as: :save_password,
            via: [:patch, :put]

    end

    unauthenticated do
      root 'users/sessions#new', as: :unauthenticated_root
    end

    authenticate :user do
    end
  end

  # Gets a JS response with all controller actions.
  get '/permissions/new/get_controller_actions', to: 'permissions#get_controller_actions', as: :get_controller_actions

  # Posts seed data from permissions in relation with their role.
  post '/permissions/generate_seeds', to: 'permissions#generate_seeds', as: :generate_seeds

  # Displays a role with every permission granted.
  get '/roles/:role_id/permissions', to: 'roles#role_permissions', as: :role_permissions

  # Creates a relationship between roles and permissions.
  post '/roles/:role_id/assign_permissions', to: 'roles#assign_permissions', as: :assign_permissions

  get '/restaurants_mobile', to: 'restaurants#index_mobile', as: :restaurants_mobile
  get '/products_mobile/:restaurant_id', to: 'products#index_mobile', as: :products_mobile

  post '/add_product/:id', to: 'products#add_product_to_cart', as: :add_product_to_cart
  post '/set_quantity/:id/:quantity', to: 'products#set_quantity', as: :set_quantity
  post '/one_less_product/:id', to: 'products#one_less_product', as: :one_less_product
  post '/delete_product_from_cart/:id', to: 'products#delete_product_from_cart', as: :delete_product_from_cart
  get '/user_cart', to: 'carts#user_cart', as: :user_cart
  get '/place_order', to: 'carts#place_order', as: :place_order
  post '/make_order/:address_id', to: 'carts#make_order', as: :make_order
end
