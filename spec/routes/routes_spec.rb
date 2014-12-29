require 'rails_helper'

RSpec.describe 'Routing', type: :routing do
  it { expect(get: '/').to route_to('welcome#index') }
  it { expect(get: '/first').to route_to('first_test#index') }
  it { expect(post: '/first').to route_to('first_test#show') }
  it { expect(get: '/second').to route_to('second_test#index') }
  it { expect(post: '/second').to route_to('second_test#send_message') }
end
