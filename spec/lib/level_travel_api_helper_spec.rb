require 'rails_helper'

RSpec.describe LevelTravelApiHelper do
  before { extend described_class }

  describe '#level_travel_api_request(module_name, api_name, options = {})' do
    let(:module_name) { 'test_module' }
    let(:api_name) { 'test_api_name' }
    let(:options) { { test_option: 'test_value' } }

    let(:request) { level_travel_api_request(module_name, api_name, options) }

    subject { request }

    it { should be_a(Typhoeus::Request) }

    its(:base_url) { should match module_name }
    its(:base_url) { should match api_name }

    context 'original_options' do
      subject { request.original_options }

      its([:params]) { should eq(options) }

      its([:headers]) do
        should include(
          'Accept' => 'application/vnd.leveltravel.v2')
      end

      its([:headers]) do
        should include(
          'Authorization' => "Token token=\"#{ENV['LT_API_KEY']}\"")
      end
    end
  end

  describe '#flights_and_nights_request
    (city_from, country_to, start_date, end_date)' do
    let(:city_from) { 'test_city' }
    let(:country_to) { 'test_country' }
    let(:start_date) { '27.09.2014' }
    let(:end_date) { '27.10.2014' }

    let(:request) do
      flights_and_nights_request(city_from, country_to, start_date, end_date)
    end

    after { request }

    it 'calls #level_travel_api_request' do
      expect(self)
        .to receive(:level_travel_api_request)
        .with('search',
              'flights_and_nights',
              'city_from' => city_from,
              'country_to' => country_to,
              'start_date' => start_date,
              'end_date' => end_date)
    end
  end

  describe '#parse_json_references_response(response, *keys)' do
    let(:json_references_response) do
      Typhoeus::Response.new(
        body: yaml_fixture('responses')['countries']
      )
    end

    let(:keys) { %w(name_en iso2) }

    let(:expected_result) do
      [%w(Egypt EG),
       %w(Russia RU),
       %w(Turkey TR)]
    end

    let(:result) do
      parse_json_references_response(json_references_response, *keys)
    end

    subject { result }

    it 'equals expected result' do
      should eq(expected_result)
    end
  end
end
