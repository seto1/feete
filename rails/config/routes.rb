Rails.application.routes.draw do
  get  'posts', to: 'posts#index'
  post 'posts', to: 'posts#create'
  post 'posts/:id', to: 'posts#update'
  get  'token', to: 'token#get'
end
