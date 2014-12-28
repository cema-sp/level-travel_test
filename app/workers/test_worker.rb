class TestWorker
  include Sidekiq::Worker

  def perform(email, fan_date, nights)
  # def level_travel_api_requests(email, fan_date, nights)
    countries = []

    all_countries_response = 
      level_travel_api_request('references', 'countries').run

    all_countries = if all_countries_response.success?
      JSON.parse(all_countries_response.body).map do
        |el| [el["name_ru"], el["iso2"]]
      end
    else
      []
    end

    all_countries.sort_by!{|country| country[0]}

    all_countries.each do |country_to|
      country_fan_response = 
        flights_and_nights_request('Moscow', country_to[1], fan_date, fan_date).run

      if country_fan_response.success?
        row = JSON.parse(country_fan_response.body).first
        countries << country_to[0] if row[1].include?(nights.to_i)
      end
    end

    SecondTestMailer.delay.countries_email(email, fan_date, nights, countries)
    # SecondTestMailer.countries_email(email, fan_date, nights, countries).deliver
    # SecondTestMailer.delay.countries_email(@email, @date, @nights, @countries)
  end

  private

  def flights_and_nights_request(city_from, country_to, start_date, end_date)
    level_travel_api_request(
      'search',
      'flights_and_nights', 
      'city_from' => city_from,
      'country_to' => country_to,
      'start_date' => start_date,
      'end_date' => end_date
    )
  end

  def level_travel_api_request(module_name, api_name, options = {})
    Typhoeus::Request.new(
      "https://level.travel/papi/#{module_name}/#{api_name}",
      method: :get,
      ssl_verifypeer: false,
      headers: {
        'Accept' => 'application/vnd.leveltravel.v2',
        'Authorization' => "Token token=\"#{ENV['LT_API_KEY']}\""
      }, 
      params: options
    )
  end
end
