require 'rails_helper'
# require 'Base64'

RSpec.describe SecondTestController, :type => :controller do
  describe "GET index" do
    before { get :index }

    subject { response }

    it { should be_success }
  end

  describe "POST send_message" do
    let(:date) { '2014-12-30' }
    let(:fan_date) { Date.parse(date).strftime('%d.%m.%Y') }
    let(:nights) { '7' }
    let(:email) { 's.a.pisarev@gmail.com' }
    let(:city_from) { 'Moscow' }

    let!(:countries_response) do
      <<-EOF
      [
        {"id":2,
        "name_ru":"Russia",
        "name_en":"Russia",
        "iso2":"RU",
        "active":true,
        "searchable":true},
        {"id":3,
        "name_ru":"Egypt",
        "name_en":"Egypt",
        "iso2":"EG",
        "active":true,
        "searchable":true},
        {"id":4,
        "name_ru":"Turkey",
        "name_en":"Turkey",
        "iso2":"TR",
        "active":true,
        "searchable":true}
      ]
      EOF
    end

    let!(:fan_response) do
      {'RU' => '{"2014-12-30":[5,6]}',
      'EG' => '{"2014-12-30":[5,7]}',
      'TR' => '{"2014-12-30":[7]}'}
    end

    let!(:to_countries_iso) do
      JSON.parse(countries_response).
        map{ |el| el["iso2"] }
    end

    let!(:countries_request) do
      stub_request(:get, 'https://level.travel/papi/references/countries').
        with(headers: { 'Accept' => 'application/vnd.leveltravel.v2',
          'Authorization' => "Token token=\"#{ENV['LT_API_KEY']}\"" }).
        to_return(status: 200, body: countries_response)
    end

    let!(:fan_request_ru) do
      country_fan_request('RU', city_from, fan_date, fan_response['RU'])
    end

    let!(:fan_request_eg) do
      country_fan_request('EG', city_from, fan_date, fan_response['EG'])
    end

    let!(:fan_request_tr) do
      country_fan_request('TR', city_from, fan_date, fan_response['TR'])
    end

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

      it 'should make request to fetch all countries from API' do
        expect(countries_request).to have_been_requested
      end

      it 'should make requests to fetch nights for each country' do
        expect(fan_request_ru).to have_been_requested
        expect(fan_request_eg).to have_been_requested
        expect(fan_request_tr).to have_been_requested
      end

      context 'delivered email' do
        it "has 's.a.pisarev@gmail.com' in 'from'" do
          expect(ActionMailer::Base.deliveries.last.from).to eq(['s.a.pisarev@gmail.com'])
        end

        it "has provided email in 'to'" do
          expect(ActionMailer::Base.deliveries.last.to).to eq([email])
        end

        it "has provided night in 'subject'" do
          expect(ActionMailer::Base.deliveries.last.subject).to match(nights)
        end

        it "has provided date in 'subject'" do
          expect(ActionMailer::Base.deliveries.last.subject).to match(date)
        end

        it "has provided night in 'body'" do
          expect(ActionMailer::Base.deliveries.last.body.encoded).to match(nights)
        end

        it "has provided date in 'body'" do
          expect(ActionMailer::Base.deliveries.last.body.encoded).to match(date)
        end

        it "has proper countries in 'body'" do
          expect(ActionMailer::Base.deliveries.last.body.encoded).
            to match('Egypt')
          expect(ActionMailer::Base.deliveries.last.body.encoded).
            to match('Turkey')
        end
      end
    end

    it 'sends an email' do
      expect{ 
        post :send_message,
          date: date,
          nights: nights,
          email: email }.
        to change{ ActionMailer::Base.deliveries.count }.by(1)
    end

    it 'calls SecondTestMailer mailer' do
      expect(SecondTestMailer).to receive(:countries_email).and_call_original
      post :send_message,
          date: date,
          nights: nights,
          email: email
    end
  end
end

def country_fan_request(country_iso, city_from, fan_date, fan_response)
  stub_request(:get, 'https://level.travel/papi/search/flights_and_nights').
    with(
      headers: { 'Accept' => 'application/vnd.leveltravel.v2',
                 'Authorization' => "Token token=\"#{ENV['LT_API_KEY']}\"" },
      query: { 'city_from' => city_from,
                'country_to' => country_iso,
                'start_date' => fan_date,
                'end_date' => fan_date}).
    to_return(status: 200, body: fan_response)
end
