Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    get "help", to: "pages#help"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    resources :users
    resources :account_activations, only: :edit
    resources :password_resets, only: %i(new edit create update)

    # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

    # Defines the root path route ("/")
    root "pages#home"
  end
end
