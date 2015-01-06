World(LevelTravelApiHelper)

Given(/body of '(.+)' response from fixture '(.+)'/) do |response, fixture|
  instance_variable_set("@#{response}_response",
                        Typhoeus::Response.new(
                          code: 200,
                          body: yaml_fixture(fixture)[response]))

  instance_variable_set("@#{response}_request",
                        stub_typhoeus_request(
                          level_travel_api_request('references', response),
                          instance_variable_get("@#{response}_response")))
end

When(/^I choose '(.*)\,\s(.*)' from '(.*)' dropdown list$/) do
  |name, value, list_name|

  @params[list_name.downcase.to_sym] = value
  select name, from: list_name
end

When(/^I enter '(.+)' in '(.+)' field$/) do |value, field_name|
  @params[field_name.downcase.to_sym] = value
  fill_in field_name, with: value
end

When(/^I click '(.*)' button$/) do |button_name|
  case button_name
  when 'Показать'
    @fan_request =
      stub_typhoeus_request(
        flights_and_nights_request(
          @params[:from_city],
          @params[:to_country],
          @start_date,
          @end_date),
        @fan_response)
  when 'Искать'
    date = Date.parse(@params[:date]).strftime('%d.%m.%Y')

    @matching_countries = []

    all_countries = 
      parse_json_references_response(@countries_response, 'name_ru', 'iso2')

    @responses_params.each do |response_params|
      nights = response_params['Nights'].split(',')

      if nights.include?(@params[:nights])
        @matching_countries << 
          all_countries.select do |name, iso2|
            iso2 == response_params['Country']
          end.map(&:first)
      end
         

      response_body = 
        { @params[date] => nights.map(&:to_i) }.to_json

      response = 
        Typhoeus::Response.new(
          code: 200,
          body: response_body)

      request = 
        stub_typhoeus_request(
          flights_and_nights_request(
            'Moscow',
            response_params['Country'],
            date,
            date),
          response)
    end

    @matching_countries.flatten!
  end

  click_link_or_button button_name
end

When(/^I visit '(.*)' path$/) do |path|
  @params = {}

  visit path
end