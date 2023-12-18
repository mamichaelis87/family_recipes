Rails.application.routes.draw do
  devise_for :admins
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "recipes#index"
  # Defines the root path route ("/")
  # root "articles#index"
  resources :recipes 
  resources :ingredients
  resources :steps
  resources :comments, only: [:create, :destroy]
  resources :quotes
  get '/all_recipes/' => 'recipes#all', as: "all_recipes"
end
