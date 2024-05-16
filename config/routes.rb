Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    get "help", to: "pages#help"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    get "/microposts", to: "pages#home"

    resources :users
    resources :microposts, only: %i(create destroy)
    resources :account_activations, only: :edit
    resources :password_resets, only: %i(new edit create update)
    resources :relationships, only: %i(create destroy)
    resources :users do
      member do
        get :following, :followers
      end
    end
    # Defines the root path route ("/")
    root "pages#home"
  end
end
