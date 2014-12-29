Rails.application.routes.draw do
  root 'welcome#index'

  get '/first' => 'first_test#index'
  post '/first' => 'first_test#show'

  get '/second' => 'second_test#index'
  post '/second' => 'second_test#send_message'
end
