class FirstTestController < ApplicationController
  include LevelTravelApiHelper

  def index
    requests =
      [[level_travel_api_request('references', 'cities'), 'name_ru', 'name_en'],
       [level_travel_api_request('references', 'countries'), 'name_ru', 'iso2']]

    hydra = Typhoeus::Hydra.hydra

    requests.each do |request, *_keys|
      hydra.queue(request)
    end

    hydra.run

    @from_cities, @to_countries =
      requests.map do |request, *keys|
        # rubocop:disable Style/MultilineTernaryOperator
        request.response.success? ?
          parse_json_references_response(request.response, *keys).to_a : []
        # rubocop:enable Style/MultilineTernaryOperator
      end
  end

  def show
    @from_city, @to_country = show_params[:from_city], show_params[:to_country]
    @start_date = (start_d = Date.today).strftime('%-d.%-m.%Y')
    @end_date = (start_d + 31).strftime('%-d.%-m.%Y')

    fan_response =
      flights_and_nights_request(@from_city, @to_country,
                                 @start_date, @end_date).run

    @fan_hash = (fan_response.success? ? JSON.parse(fan_response.body) : {})
  end

  private

  def show_params
    params.permit(:from_city, :to_country)
  end
end
