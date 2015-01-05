require 'rails_helper'

RSpec.describe FirstTestController, type: :controller do
  before { extend LevelTravelApiHelper }

  describe 'GET index' do
    let!(:cities_response) do
      Typhoeus::Response.new(code: 200,
        body: yaml_fixture('responses')['cities'])
    end
    let!(:countries_response) do
      Typhoeus::Response.new(code: 200,
        body: yaml_fixture('responses')['countries'])
    end

    let!(:from_cities) do
      parse_json_references_response(cities_response, 'name_ru', 'name_en')
    end

    let!(:to_countries) do
      parse_json_references_response(countries_response, 'name_ru', 'iso2')
    end

    let!(:cities_request) do
      stub_typhoeus_request(
        level_travel_api_request('references', 'cities'),
        cities_response)
    end

    let!(:countries_request) do
      stub_typhoeus_request(
        level_travel_api_request('references', 'countries'),
        countries_response)
    end

    before do
      get :index
    end

    subject { response }

    it { should be_success }

    it { should render_template('index') }

    it 'makes request to fetch all cities from API' do
      expect(cities_request).to have_been_requested
    end

    it 'makes request to fetch all countries from API' do
      expect(countries_request).to have_been_requested
    end

    it "assigns all cities as '@from_cities'" do
      expect(assigns(:from_cities)).to eq(from_cities)
    end

    it "assigns all countries as '@to_countries'" do
      expect(assigns(:to_countries)).to eq(to_countries)
    end
  end

  describe 'POST show' do
    let(:from_city) { 'Moscow' }
    let(:to_country) { 'EG' }
    let(:fake_today_date) { Date.parse('2014-12-01') }
    let(:current_date) { fake_today_date.strftime('%-d.%-m.%Y') }
    let(:offseted_date) { (fake_today_date + 31).strftime('%-d.%-m.%Y') }

    let(:fan_response_body) { yaml_fixture('responses')['flights_and_nights'] }

    let!(:fan_response) do
      Typhoeus::Response.new(code: 200,
        body: fan_response_body)
    end

    let(:max_nights) do
      JSON.parse(fan_response.body).max_by{ |line| line[1].size }[1].size
    end

    let!(:fan_request) do
      stub_typhoeus_request(
        flights_and_nights_request(
          from_city,
          to_country,
          current_date,
          offseted_date),
        fan_response)
    end

    before do
      allow(Date).to receive(:today).and_return(fake_today_date)
      post :show, from_city: from_city, to_country: to_country
    end

    subject { response }

    it { should be_success }

    it { should render_template('show') }

    it 'makes request to fetch flights and nights from API' do
      expect(fan_request).to have_been_requested
    end

    it "assigns provided city as '@from_city'" do
      expect(assigns(:from_city)).to eq(from_city)
    end

    it "assigns provided country as '@to_country'" do
      expect(assigns(:to_country)).to eq(to_country)
    end

    it "assigns current date as '@start_date'" do
      expect(assigns(:start_date)).to eq(current_date)
    end

    it "assigns offseted date as '@end_date'" do
      expect(assigns(:end_date)).to eq(offseted_date)
    end

    it "assigns response body hash as '@fan_hash'" do
      expect(assigns(:fan_hash)).to eq(JSON.parse(fan_response_body))
    end

    it "assigns max days count as '@max_days'" do
      expect(assigns(:max_nights)).to eq(max_nights)
    end
  end
end
