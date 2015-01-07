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

  set_param(list_name, value)
  select name, from: list_name
end

When(/^I enter '(.+)' in '(.+)' field$/) do |value, field_name|
  set_param(field_name, value)
  fill_in field_name, with: value
end

When(/^I click '(.*)' button$/) do |button_name|
  click_link_or_button button_name
end

When(/^I visit '(.*)' path$/) do |path|
  visit path
end
