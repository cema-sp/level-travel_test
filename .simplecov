require 'coveralls'

SimpleCov.profiles.define 'rails_custom' do
  load_profile 'rails'

  add_group 'Workers', 'app/workers'
end

SimpleCov.formatters << Coveralls::SimpleCov::Formatter

SimpleCov.start 'rails_custom'
