Rails.application.routes.draw do
  get    'posts',       to: 'posts#index'
  post   'posts',       to: 'posts#create'
  post   'posts/:id',   to: 'posts#update'
  delete 'posts/:id',   to: 'posts#destroy'
  post   'token',       to: 'token#create'

  get    'test',        to: 'test#index'
end
