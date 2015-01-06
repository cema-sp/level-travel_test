# require "#{File.dirname(__FILE__)}/../../support/env.rb"
# require "#{File.dirname(__FILE__)}/../../step_definitions/common_steps.rb"

Given(/^available nights for selected date:$/) do |table|
  @responses_params = table.hashes
end

Then(/^I see confirmation page$/) do
  expect(page).to have_content(@params[:date])
  expect(page).to have_content(@params[:night])
  expect(page).to have_content(@params[:email])
end

Then(/^I receive email with proper countries$/) do
  @matching_countries.each do |matching_country|
    expect(ActionMailer::Base.deliveries.last.text_part.body.decoded)
      .to match(matching_country)
  end
end
