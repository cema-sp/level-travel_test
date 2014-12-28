# require 'Date'

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

    @from_cities.sort_by!{ |city| city[0] }

    @to_countries = if all_countries_response.success?
      JSON.parse(all_countries_response.body).map do
        |el| [el["name_ru"], el["iso2"]]
      end
    else
      []
    end

    @to_countries.sort_by!{ |country| country[0] }
  end

  def show
    @from_city = show_params[:from_city]
    @to_country = show_params[:to_country]
    @start_date = Time.now.strftime('%-d.%-m.%Y')
    @end_date = (Time.now + 60 * 60 * 24 * 31).strftime('%-d.%-m.%Y')
    @max_nights = 0

    fan_response = 
      flights_and_nights_request(@from_city, @to_country, @start_date, @end_date).
        run

    flights_and_nights = if fan_response.success?
      JSON.parse(fan_response.body)
    else
      {}
    end

    start_d = Date.parse(@start_date)
    end_d = Date.parse(@end_date)

    @table_data = []
    table_row = []

    # binding.pry

    # For previous days
    (start_d.cwday - 1).times { table_row << nil }
    # For 
    (start_d..end_d).each do |date|
      if (nights = flights_and_nights[date.strftime('%Y-%m-%d')])
        table_row << { date.day.to_s => nights.map(&:to_s) }
        @max_nights = [@max_nights, nights.size].max
      else
        table_row << date.day.to_s
      end

      if table_row.size == 7
        @table_data << table_row.clone
        table_row.clear
      end
    end
    # For next days
    unless table_row.empty?
      (7 - table_row.size).times { table_row << nil }
      @table_data << table_row
    end 
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
    # binding.pry
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

  def show_params
    params.permit(:from_city, :to_country)
  end
end
