require 'rails_helper'

RSpec.describe 'second_test/index', type: :view do
  before do
    render
  end

  subject { rendered }

  it { should have_field('email', type: 'email') }

  it { should have_field('date', type: 'date') }

  it { should have_field('nights', type: 'number') }

  it { should have_selector("form[method=\"post\"][action=\"#{second_path}\"]") }

  it { should have_selector("input[type=\"submit\"][value=\"Search\"]") }
end
