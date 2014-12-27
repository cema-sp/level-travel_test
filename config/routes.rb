Rails.application.routes.draw do
  root 'first_test#index'

  get '/first' => 'first_test#index'
  post '/first' => 'first_test#show'
end
