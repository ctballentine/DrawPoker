Rails.application.routes.draw do
  resources :games, only: [:index, :new, :show, :edit]

  resources :poker_help, only: [:index]
  resources :poker_stat, only: [:index]
  root 'games#index'
end
