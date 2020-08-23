Rails.application.routes.draw do
  get 'welcome/index'

  resources :sessions

  post '/login', to: 'sessions#create', as: 'login'

  delete '/logout', to: 'sessions#delete', as: 'logout'

  root 'welcome#index'
  
  mount GuiderCms::Engine => "/guider_cms"
end
