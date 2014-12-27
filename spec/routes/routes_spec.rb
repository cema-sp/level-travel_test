require 'rails_helper'

RSpec.describe 'Routing', type: :routing do
  it { expect(get: '/first').to route_to('first_test#index') }
  it { expect(post: '/first').to route_to('first_test#show') }
end
