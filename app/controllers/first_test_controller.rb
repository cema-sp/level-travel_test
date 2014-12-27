class FirstTestController < ApplicationController
  def index
    all_cities_response = 
      level_travel_api_request('references', 'cities').run

    all_countries_response = 
      level_travel_api_request('references', 'countries').run

    @from_cities = if all_cities_response.success?
      JSON.parse(all_cities_response.body).map do
        |el| [el["name_ru"], el["name_en"]]
      end
    else
      []
    end

    @to_countries = if all_countries_response.success?
      JSON.parse(all_countries_response.body).map do
        |el| [el["name_ru"], el["iso2"]]
      end
    else
      []
    end
  end

  def show
    @from_city = show_params[:from_city]
    @to_country = show_params[:to_country]
    @start_date = Time.now.strftime('%-d.%-m.%Y')
    @end_date = (Time.now + 60 * 60 * 24 * 31).strftime('%-d.%-m.%Y')
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

  def level_travel_api_request(module_name, api_name, *params)
    Typhoeus::Request.new(
      "https://level.travel/papi/#{module_name}/#{api_name}",
      method: :get,
      ssl_verifypeer: false,
      headers: {
        'Accept' => 'application/vnd.leveltravel.v2',
        'Authorization' => "Token token=\"#{ENV['LT_API_KEY']}\""
      }, 
      params: params
    )
  end

  def show_params
    params.permit(:from_city, :to_country)
  end
end
