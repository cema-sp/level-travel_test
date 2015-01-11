require 'coveralls'

SimpleCov.profiles.define 'rails_custom' do
  load_profile 'rails'

  add_group 'Workers', 'app/workers'
end

if ENV['TRAVIS'] && ENV['TRAVIS_RUBY_VERSION']=='2.0.0'
  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
end

SimpleCov.start 'rails_custom'
