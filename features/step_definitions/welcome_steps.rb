# require "#{File.dirname(__FILE__)}/../../support/env.rb"
# require "#{File.dirname(__FILE__)}/../../step_definitions/common_steps.rb"

Then(/^I see the proper index page$/) do
  expect(page).to have_title('For Level-Travel by S. Pisarev')
  expect(page).to have_selector("a[href=\"mailto:s.a.pisarev@gmail.com\"]")
end

Then(/^I see '(.+)' link$/) do |link_path|
  expect(page).to have_selector("a[href=\"#{link_path}\"]")
end
