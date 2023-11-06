Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "recipes#index"
  # Defines the root path route ("/")
  # root "articles#index"
  resources :recipes 
  resources :ingredients
  resources :steps
  get '/all_recipes/' => 'recipes#all', as: "all_recipes"
end
