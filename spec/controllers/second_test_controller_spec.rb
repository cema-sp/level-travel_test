require 'rails_helper'

RSpec.describe SecondTestController, type: :controller do
  describe 'GET index' do
    before { get :index }

    subject { response }

    it { should be_success }
    it { should render_template('index') }
  end

  describe 'POST send_message' do
    let(:date) { '2014-12-30' }
    let(:fan_date) { Date.parse(date).strftime('%d.%m.%Y') }
    let(:nights) { '7' }
    let(:email) { 's.a.pisarev@gmail.com' }
    let(:city_from) { 'Moscow' }

    describe 'after post' do
      before do
        post :send_message,
             date: date,
             nights: nights,
             email: email
      end

      subject { response }

      it { should be_success }
      it { should render_template('send_message') }

      describe 'assignments:' do
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
    end

    describe 'using sidekiq' do
      it 'schedules API requests with Sidekiq' do
        expect do
          post :send_message,
               date: date,
               nights: nights,
               email: email
        end.to change { TestWorker.jobs.count }.by(1)
      end

      describe 'perform_async' do
        after do
          post :send_message,
               date: date,
               nights: nights,
               email: email
        end
        
        it 'calls Sidekiq worker' do
          expect(TestWorker)
            .to receive(:perform_async)
            .with(email, fan_date, nights)
        end
      end
    end
  end
end
