require 'rails_helper'

RSpec.describe 'second_test/index', type: :view do
  before { render }

  subject { rendered }

  it { should have_field('email', type: 'email') }
  it { should have_field('date', type: 'date') }
  it { should have_field('nights', type: 'number') }

  it do
    should have_selector(
      "form[method=\"post\"][action=\"#{second_path}\"]")
  end

  it { should have_selector("input[type=\"submit\"][value=\"Искать\"]") }
end
