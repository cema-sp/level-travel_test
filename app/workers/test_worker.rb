class TestWorker
  include Sidekiq::Worker
  include LevelTravelApiHelper

  def perform(email, fan_date, nights)
    hydra = Typhoeus::Hydra.hydra

    requests =
      all_countries_from_api('name_ru', 'iso2').map do |country_to|
        [country_to[0]] <<
        hydra.queue(
          flights_and_nights_request(
            'Moscow', country_to[1], fan_date, fan_date)).last
      end

    hydra.run

    SecondTestMailer.delay
      .countries_email(
        email,
        fan_date,
        nights,
        get_countries_from_requests(
          parse_and_filter_fan_requests(
            requests,
            nights)))
  end

  private

  def all_countries_from_api(*keys)
    all_countries_response =
      level_travel_api_request('references', 'countries').run

    if all_countries_response.success?
      parse_json_references_response(
        all_countries_response, *keys).to_a
    else
      []
    end
  end

  def parse_and_filter_fan_requests(requests, nights)
    requests.select do |country_request|
      response = country_request[1].response
      (response.success? &&
        JSON.parse(response.body).first[1].include?(nights.to_i))
    end
  end

  def get_countries_from_requests(requests)
    requests.map { |country_request| country_request[0] }
  end
end
