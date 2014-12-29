require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  describe "GET index" do
    before { get :index }

    subject { response }

    it { should be_success }
  end
end
