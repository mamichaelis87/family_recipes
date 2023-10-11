Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root_path "recipes#index"
  # Defines the root path route ("/")
  # root "articles#index"
  resources :recipes 
  resources :ingredients
  resources :steps
end
