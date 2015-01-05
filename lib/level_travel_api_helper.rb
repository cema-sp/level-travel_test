module LevelTravelApiHelper
  # Return Request to Level-Travel API
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

  # Return Request to Level-Travel API (flights & nights)
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

  # Parses JSON response and returns requested keys sorted by first key
  def parse_json_references_response(response, *keys)
    JSON.parse(response.body).inject([]) do |result, element|
      result << keys.map { |key| element[key] }
    end.sort_by!(&:first)
  end
end
