require 'rails_helper'

RSpec.describe SecondTestController, type: :controller do
  describe 'GET index' do
    before { get :index }

    subject { response }

    it { should be_success }
  end

  describe 'POST send_message' do
    let(:date) { '2014-12-30' }
    let(:fan_date) { Date.parse(date).strftime('%d.%m.%Y') }
    let(:nights) { '7' }
    let(:email) { 's.a.pisarev@gmail.com' }
    let(:city_from) { 'Moscow' }

    context 'after post' do
      before do
        ActionMailer::Base.deliveries = []
        post :send_message,
             date: date,
             nights: nights,
             email: email
      end

      subject { response }

      it { should be_success }

      it "assigns provided date as '@date'" do
        expect(assigns(:date)).to eq(date)
      end

      it "assigns provided nights as '@nights'" do
        expect(assigns(:nights)).to eq(nights)
      end

      it "assigns provided email as '@email'" do
        expect(assigns(:email)).to eq(email)
      end
    end

    context 'using sidekiq' do
      it 'schedules API requests with Sidekiq' do
        expect do
          post :send_message,
               date: date,
               nights: nights,
               email: email
        end
          .to change { TestWorker.jobs.count }.by(1)
      end

      it 'calls Sidekiq worker' do
        expect(TestWorker)
          .to receive(:perform_async)
          .with(email, fan_date, nights)
          .and_call_original
        post :send_message,
             date: date,
             nights: nights,
             email: email
      end
    end
  end
end
