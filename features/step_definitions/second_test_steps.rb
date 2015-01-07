# require "#{File.dirname(__FILE__)}/../../support/env.rb"
# require "#{File.dirname(__FILE__)}/../../step_definitions/common_steps.rb"

Given(/^available nights for selected date:$/) do |table|
  @responses_params = table.hashes
end

When(/^to run second test (.+)$/) do |next_step_name|
  @matching_countries = []

  all_countries =
    parse_json_references_response(@countries_response, 'name_ru', 'iso2')

  matching_params =
    @responses_params.select do |response_params|
      response_params['Nights'].split(',').include?(@params[:nights])
    end

  @matching_countries =
    matching_params.map do |matching_param|
      all_countries.select do |_name, iso2|
        iso2 == matching_param['Country']
      end
    end

  @matching_countries.map!(&:first).map!(&:first)

  requests_for(@responses_params)

  step next_step_name
end

Then(/^I see confirmation page$/) do
  %i(date night email).each do |key|
    expect(page).to have_content(@params[key])
  end
end

Then(/^I receive email with proper countries$/) do
  @matching_countries.each do |matching_country|
    expect(ActionMailer::Base.deliveries.last.text_part.body.decoded)
      .to match(matching_country)
  end
end

module SecondTestStepsHelpers
  def requests_for(responses_params)
    date = Date.parse(@params[:date]).strftime('%d.%m.%Y')

    responses_params.map do |response_params|
      stub_typhoeus_request(
        flights_and_nights_request(
          'Moscow',
          response_params['Country'],
          date,
          date),
        response_for(response_params['Nights']))
    end
  end

  def response_for(nights_str)
    Typhoeus::Response.new(
      code: 200,
      body: { @params[:date] => nights_str.split(',').map(&:to_i) }
        .to_json)
  end
end

World(SecondTestStepsHelpers)
