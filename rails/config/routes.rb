Rails.application.routes.draw do
  get  'posts',        to: 'posts#index'
  post 'posts',        to: 'posts#create'
  post 'posts/:id',    to: 'posts#update'
  post 'token/jwt',    to: 'token#jwt'
  post 'token/decode', to: 'token#decode'
  post 'init',         to: 'init#index'
end
