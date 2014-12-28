Rails.application.routes.draw do
  get 'second_test/index'

  root 'first_test#index'

  get '/first' => 'first_test#index'
  post '/first' => 'first_test#show'

  get '/second' => 'second_test#index'
  post '/second' => 'second_test#send_message'
end
