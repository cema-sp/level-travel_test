class FirstTestController < ApplicationController
  include LevelTravelApiHelper

  def index
    all_cities_request = level_travel_api_request('references', 'cities')
    all_countries_request = level_travel_api_request('references', 'countries')

    hydra = Typhoeus::Hydra.hydra
    hydra.queue(all_cities_request)
    hydra.queue(all_countries_request)

    hydra.run

    @from_cities, @to_countries = [], []
    
    if all_cities_request.response.success?
      @from_cities = 
        parse_json_references_response(
          all_cities_request.response,
          'name_ru', 'name_en')
    end

    if all_countries_request.response.success?
      @to_countries = 
        parse_json_references_response(
          all_countries_request.response,
          'name_ru', 'iso2')
    end
  end

  def show
    @from_city, @to_country = show_params[:from_city], show_params[:to_country]

    start_d = Date.today
    end_d = start_d + 31

    @start_date = start_d.strftime('%-d.%-m.%Y')
    @end_date = end_d.strftime('%-d.%-m.%Y')

    fan_response =
      flights_and_nights_request(
        @from_city,
        @to_country,
        @start_date,
        @end_date)
      .run

    @fan_hash = 
      (fan_response.success? ? JSON.parse(fan_response.body) : {} )

    @max_nights = @fan_hash.max_by{ |line| line[1].size }[1].size
  end

  private

  def show_params
    params.permit(:from_city, :to_country)
  end
end
