# require "#{File.dirname(__FILE__)}/../../support/env.rb"
# require "#{File.dirname(__FILE__)}/../../step_definitions/common_steps.rb"

Then(/^I see the proper title$/) do
  expect(page).to have_title('For Level-Travel by S. Pisarev')
end

Then(/^I see author email$/) do
  expect(page).to have_selector("a[href=\"mailto:s.a.pisarev@gmail.com\"]")
end

Then(/^I see link to '(.+)'$/) do |link_path|
  expect(page).to have_selector("a[href=\"#{link_path}\"]")
end
