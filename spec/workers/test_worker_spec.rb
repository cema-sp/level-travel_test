require 'rails_helper'

RSpec.describe TestWorker do
  before { extend LevelTravelApiHelper }

  describe '#perform(email, fan_date, nights)' do
    let(:date) { '2014-12-30' }
    let(:fan_date) { Date.parse(date).strftime('%d.%m.%Y') }
    let(:nights) { '7' }
    let(:email) { 's.a.pisarev@gmail.com' }
    let(:city_from) { 'Moscow' }

    let!(:countries_response) do
      Typhoeus::Response.new(code: 200,
                             body: yaml_fixture('responses')['countries'])
    end

    let!(:countries_request) do
      stub_typhoeus_request(
        level_travel_api_request('references', 'countries'),
        countries_response)
    end

    let!(:to_countries) do
      parse_json_references_response(countries_response, 'name_ru', 'iso2')
    end

    let!(:fan_responses_bodies) do
      ["{\"#{date}\":[5,6]}",
       "{\"#{date}\":[5,#{nights}]}",
       "{\"#{date}\":[#{nights}]}"]
    end

    let!(:expected_countries) { to_countries[1, 2].map { |el| el[0] } }

    let!(:fan_responses) do
      fan_responses_bodies.map do |fan_responses_body|
        Typhoeus::Response.new(code: 200,
                               body: fan_responses_body)
      end
    end

    let!(:fan_requests) do
      # binding.pry
      to_countries.each_with_index.map do |to_country, index|
        stub_typhoeus_request(
          flights_and_nights_request(
            city_from,
            to_country[1],
            fan_date,
            fan_date),
          fan_responses[index])
      end
    end

    before(:all) { Sidekiq::Testing.inline! }
    after(:all) { Sidekiq::Testing.fake! }

    context "after '#perform_async'" do
      before do
        described_class.perform_async(email, fan_date, nights)
      end

      describe 'API requests:' do
        it 'makes request to fetch all countries from API' do
          expect(countries_request).to have_been_requested
        end

        it 'makes requests to fetch nights for each country' do
          fan_requests.each do |fan_request|
            expect(fan_request).to have_been_requested
          end
        end
      end
    end

    describe 'with Sidekiq' do
      around do |example|
        Sidekiq::Testing.fake!(&example)
      end
      before do
        described_class.jobs.clear
        Sidekiq::Extensions::DelayedMailer.jobs.clear
        described_class.perform_async(email, fan_date, nights)
      end

      it 'schedules delayed mail delivery' do
        expect { described_class.drain }
          .to change { Sidekiq::Extensions::DelayedMailer.jobs.size }.by(1)
      end

      describe 'scheduled delayed mail' do
        before { described_class.drain }
        after { Sidekiq::Extensions::DelayedMailer.drain }

        specify 'SecondTestMailer called' do
          expect(SecondTestMailer)
            .to receive(:countries_email)
            .with(email, fan_date, nights, expected_countries)
        end
      end
    end
  end
end
