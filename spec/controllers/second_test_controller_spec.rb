require 'rails_helper'

RSpec.describe SecondTestController, :type => :controller do
  describe "GET index" do
    before { get :index }

    subject { response }

    it { should be_success }
  end

  describe "POST send_message" do
    before do
      post :send_message
    end

    subject { response }

    it { should be_success }
  end
end
