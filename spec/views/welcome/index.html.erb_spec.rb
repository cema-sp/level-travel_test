require 'rails_helper'

RSpec.describe 'welcome/index', type: :view do
  before { render }

  subject { rendered }

  # it { should have_title('For Level-Travel by S. Pisarev') }

  it { should have_selector("a[href=\"mailto:s.a.pisarev@gmail.com\"]") }
end
