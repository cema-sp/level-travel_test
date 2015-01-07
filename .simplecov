require 'coveralls'

SimpleCov.profiles.define 'rails_custom' do
  load_profile 'rails'

  add_group 'Workers', 'app/workers'
end

SimpleCov.formatter = Coveralls::SimpleCov::Formatter if ENV['ON_TRAVIS']

SimpleCov.start 'rails_custom'
