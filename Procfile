web: bundle exec unicorn -p $PORT -E $RAILS_ENV -c ./config/unicorn.rb
worker: bundle exec sidekiq -C config/sidekiq.yml -v
