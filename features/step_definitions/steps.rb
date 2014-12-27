Given(/^It is '(\d+)\-(\d+)\-(\d+)'$/) do |year, month, day|
  allow(Time).to receive(:now).and_return(Time.mktime(year,month,day))

  @start_date = Time.now.strftime('%-d.%-m.%Y')
  @end_date = (Time.now + 60 * 60 * 24 * 31).strftime('%-d.%-m.%Y')

  @params = {}
  @cities_response = <<-EOF
    [
      {"id":2,
      "name_ru":"Москва",
      "name_en":"Moscow",
      "active":true,
      "featured":false,
      "iata":"MOW",
      "country":{"id":2,
        "name_ru":"Россия",
        "name_en":"Russia",
        "iso2":"RU",
        "active":true}},
      {"id":1261,
      "name_ru":"Анапа",
      "name_en":"Anapa",
      "active":true,
      "featured":false,
      "iata":null,
      "country":{
        "id":2,
        "name_ru":"Россия",
        "name_en":"Russia",
        "iso2":"RU",
        "active":true}}
    ]
    EOF

  @countries_response = <<-EOF
    [
      {"id":2,
      "name_ru":"Россия",
      "name_en":"Russia",
      "iso2":"RU",
      "active":true,
      "searchable":true},
      {"id":3,
      "name_ru":"Египет",
      "name_en":"Egypt",
      "iso2":"EG",
      "active":true,
      "searchable":true},
      {"id":4,
      "name_ru":"Турция",
      "name_en":"Turkey",
      "iso2":"TR",
      "active":true,
      "searchable":true}
    ]
    EOF

  @cities_request = 
    stub_request(:get, 'https://level.travel/papi/references/cities').
      with(headers: { 'Accept' => 'application/vnd.leveltravel.v2',
        'Authorization' => "Token token=\"#{ENV['LT_API_KEY']}\"" }).
      to_return(status: 200, body: @cities_response)

  @countries_request = 
    stub_request(:get, 'https://level.travel/papi/references/countries').
      with(headers: { 'Accept' => 'application/vnd.leveltravel.v2',
        'Authorization' => "Token token=\"#{ENV['LT_API_KEY']}\"" }).
      to_return(status: 200, body: @countries_response)

end

Given(/^nights for '(.*)' are:$/) do |country, table|
  # table is a Cucumber::Ast::Table
  nil # express the regexp above with the code you wish you had
end

When(/^I visit '(.*)' path$/) do |path|
  visit path
end

When(/^I choose '(.*)\,\s(.*)' from '(.*)' dropdown list$/) do |name, value, list_name|
  @params[list_name.downcase.to_sym] = value
  select name, from: list_name
end

When(/^I click '(.*)' button$/) do |button_name|
  click_link_or_button button_name
end

Then(/^I see the proper header$/) do
  expect(page).to have_content(
    "Period: #{@start_date} - #{@end_date}, 
    From: #{@params[:from_city]}, 
    To: #{@params[:to_country]}"
  )
end

Then(/^I see the proper calendar:$/) do |table|
  # table is a Cucumber::Ast::Table
  # expect(page).to have_content(
  #   "Period: #{@start_date} - #{@end_date}, 
  #   From: #{@params[:from_city]}, 
  #   To: #{@params[:to_country]}"
  # )
  %w{ Пн Вт Ср Чт Пт Сб Вс }.each do |dow|
    expect(page).to have_selector('table thead th', text: dow)
  end

  expect(page).to have_xpath('//table/tbody/tr/td[0][text()="1"]')
end
