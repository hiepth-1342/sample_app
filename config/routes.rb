Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    get "help", to: "pages#help"
    get "pages/users"
    # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

    # Defines the root path route ("/")
    root "pages#home"
  end
end
