require 'rails_helper'

RSpec.describe FirstTestController, type: :controller do
  describe 'GET index' do
    # let!(:api_key) { '58d6ea8b979d350fc432bcdebb37de2b' }
    let!(:cities_response) do
      <<-EOF
      [
        {"id":2,
        "name_ru":"Москва",
        "name_en":"Moscow",
        "active":true,
        "featured":false,
        "iata":"MOW",
        "country":{"id":2,
          "name_ru":"Россия",
          "name_en":"Russia",
          "iso2":"RU",
          "active":true}},
        {"id":1261,
        "name_ru":"Анапа",
        "name_en":"Anapa",
        "active":true,
        "featured":false,
        "iata":null,
        "country":{
          "id":2,
          "name_ru":"Россия",
          "name_en":"Russia",
          "iso2":"RU",
          "active":true}}
      ]
      EOF
    end

    let!(:countries_response) do
      <<-EOF
      [
        {"id":2,
        "name_ru":"Россия",
        "name_en":"Russia",
        "iso2":"RU",
        "active":true,
        "searchable":true},
        {"id":3,
        "name_ru":"Египет",
        "name_en":"Egypt",
        "iso2":"EG",
        "active":true,
        "searchable":true},
        {"id":4,
        "name_ru":"Турция",
        "name_en":"Turkey",
        "iso2":"TR",
        "active":true,
        "searchable":true}
      ]
      EOF
    end

    let!(:from_cities) do
      JSON.parse(cities_response).map{ |el| [el["name_ru"], el["name_en"]] }
    end

    let!(:to_countries) do
      JSON.parse(countries_response).map{ |el| [el["name_ru"], el["iso2"]] }
    end

    let!(:cities_request) do
      stub_request(:get, 'https://level.travel/papi/references/cities').
        with(headers: { 'Accept' => 'application/vnd.leveltravel.v2',
          'Authorization' => "Token token=\"#{ENV['LT_API_KEY']}\"" }).
        to_return(status: 200, body: cities_response)
    end

    let!(:countries_request) do
      stub_request(:get, 'https://level.travel/papi/references/countries').
        with(headers: { 'Accept' => 'application/vnd.leveltravel.v2',
          'Authorization' => "Token token=\"#{ENV['LT_API_KEY']}\"" }).
        to_return(status: 200, body: countries_response)
    end

    before do
      get :index
    end

    subject { response }

    it { should be_success }

    it { should render_template('index') }

    it 'should make request to fetch all cities from API' do
      expect(cities_request).to have_been_requested
    end

    it 'should make request to fetch all countries from API' do
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
    # let(:current_date) { Time.now.strftime('%-d.%-m.%Y') }
    # let(:offseted_date) { (Time.now + 31.day).strftime('%-d.%-m.%Y') }
    let(:current_date) { Time.mktime(2014,12,01).strftime('%-d.%-m.%Y') }
    let(:offseted_date) { Time.mktime(2015,01,01).strftime('%-d.%-m.%Y') }

    let!(:fan_response) do
      <<-EOF
      {
      "2014-12-01":[5,8],
      "2014-12-08":[5,8],
      "2014-12-15":[5,8],
      "2014-12-22":[5,8],
      "2014-12-29":[5,8]
      }
      EOF
    end

    let(:table_data) do
      [[{'1' => ['5','8']},'2', '3','4','5','6','7'],
      [{'8' => ['5','8']},'9', '10','11','12','13','14'],
      [{'15' => ['5','8']},'16', '17','18','19','20','21'],
      [{'22' => ['5','8']},'23', '24','25','26','27','28'],
      [{'29' => ['5','8']},'30', '31', '1',nil,nil,nil]]
    end

    let!(:fan_request) do
      stub_request(:get, 'https://level.travel/papi/search/flights_and_nights').
        with(
          headers: { 'Accept' => 'application/vnd.leveltravel.v2',
                     'Authorization' => "Token token=\"#{ENV['LT_API_KEY']}\"" },
          query: { 'city_from' => from_city,
                    'country_to' => to_country,
                    'start_date' => current_date,
                    'end_date' => offseted_date}).
        to_return(status: 200, body: fan_response)
    end

    before do
      allow(Time).to receive(:now).and_return(Time.mktime(2014,12,01))
      post :show, from_city: from_city, to_country: to_country
    end

    subject { response }

    it { should be_success }

    it { should render_template('show') }

    it 'should make request to fetch flights and nights from API' do
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

    it "assigns calendar table as '@table_data'" do
      expect(assigns(:table_data)).to eq(table_data)
    end
  end
end
