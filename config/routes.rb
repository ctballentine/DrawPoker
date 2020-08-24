Rails.application.routes.draw do
  get 'poker_help/index'

  get 'poker_stat/index'

  get 'games/new'

  get 'games/index'

  get 'games/show'

  get 'games/edit'

  root 'games#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
