Given(/^It is '(\d+)\-(\d+)\-(\d+)'$/) do |year, month, day|
  allow(Time).to receive(:now).and_return(Time.mktime(year,month,day))

  @start_date = Time.now.strftime('%-d.%-m.%Y')
  @end_date = (Time.now + 60 * 60 * 24 * 31).strftime('%-d.%-m.%Y')

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

end

Given(/^nights for '(.*)' are:$/) do |country, table|
  # require 'Date'

  @fan_response = {}
  table.hashes.each do |row|
    @fan_response[Date.parse("2014-12-#{row['Date']}").strftime('%Y-%m-%d')] = 
      row['Nights'].split(',').map(&:to_i)
  end

  @fan_response = @fan_response.to_json
end

When(/^I visit '(.*)' path$/) do |path|
  @params = {}

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

  visit path
end

When(/^I choose '(.*)\,\s(.*)' from '(.*)' dropdown list$/) do |name, value, list_name|
  @params[list_name.downcase.to_sym] = value
  select name, from: list_name
end

When(/^I click '(.*)' button$/) do |button_name|
  @fan_request = 
    stub_request(:get, 'https://level.travel/papi/search/flights_and_nights').
      with(
        headers: { 'Accept' => 'application/vnd.leveltravel.v2',
                   'Authorization' => "Token token=\"#{ENV['LT_API_KEY']}\"" },
        query: { 'city_from' => @params[:from_city],
                  'country_to' => @params[:to_country],
                  'start_date' => @start_date,
                  'end_date' => @end_date}).
      to_return(status: 200, body: @fan_response)

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
  %w{ Пн Вт Ср Чт Пт Сб Вс }.each do |dow|
    expect(page).to have_selector('table thead th', text: dow)
  end

  # binding.pry
  table_data = []
  tmp_row = []

  table.hashes.each do |table_row|
    %w{ Mo Tu We Th Fr Sa Su }.each do |wday|
      if parsed = /(\d+)\s\((.*)\)/.match(table_row[wday])
        tmp_row << { parsed[1] => parsed[2].split(',').map(&:to_i) }
      else
        tmp_row << ( table_row[wday].empty? ? nil : table_row[wday] )
      end
    end
    table_data << tmp_row.clone
    tmp_row.clear
  end

  table_data.each_with_index do |table_row, row_index|
    table_row.each_with_index do |table_cell, cell_index|
      case table_cell
      when Hash
        expect(page).to have_xpath(
          "//table/tbody\
          /tr[#{row_index + 1}]\
          /td[#{cell_index + 1}]\
          [strong/text()=\"#{table_cell.first[0]}\"]\
          [p/text()=\"#{table_cell.first[1].join(', ')}\"]")
      when String
        expect(page).to have_xpath(
          "//table/tbody\
          /tr[#{row_index + 1}]\
          /td[#{cell_index + 1}]\
          /strong[text()=\"#{table_cell}\"]")
      end
    end
  end
end

Given(/^avaliable countries for '(.+)' and '(\d+)' nights are:$/) do |date, nights, table|
  @available_countries = table.hashes.map { |row| row['Country'] }
  @requested_date = date
  @requested_date_fan = Date.parse(@requested_date).strftime('%d.%m.%Y')
  @requested_nights = nights
  ActionMailer::Base.deliveries = []

  @countries_response = <<-EOF
  [
    {"id":2,
    "name_ru":"Russia",
    "name_en":"Russia",
    "iso2":"RU",
    "active":true,
    "searchable":true},
    {"id":3,
    "name_ru":"Egypt",
    "name_en":"Egypt",
    "iso2":"EG",
    "active":true,
    "searchable":true},
    {"id":4,
    "name_ru":"Turkey",
    "name_en":"Turkey",
    "iso2":"TR",
    "active":true,
    "searchable":true}
  ]
  EOF

  @fan_request_ru = 
    stub_request(:get, 'https://level.travel/papi/search/flights_and_nights').
      with(
        headers: { 'Accept' => 'application/vnd.leveltravel.v2',
                   'Authorization' => "Token token=\"#{ENV['LT_API_KEY']}\"" },
        query: { 'city_from' => 'Moscow',
                  'country_to' => 'RU',
                  'start_date' => @requested_date_fan,
                  'end_date' => @requested_date_fan}).
      to_return(status: 200, body: '{"2014-12-30":[5,6]}')

  @fan_request_eg = 
    stub_request(:get, 'https://level.travel/papi/search/flights_and_nights').
      with(
        headers: { 'Accept' => 'application/vnd.leveltravel.v2',
                   'Authorization' => "Token token=\"#{ENV['LT_API_KEY']}\"" },
        query: { 'city_from' => 'Moscow',
                  'country_to' => 'EG',
                  'start_date' => @requested_date_fan,
                  'end_date' => @requested_date_fan}).
      to_return(status: 200, body: '{"2014-12-30":[5,7]}')

  @fan_request_tr = 
    stub_request(:get, 'https://level.travel/papi/search/flights_and_nights').
      with(
        headers: { 'Accept' => 'application/vnd.leveltravel.v2',
                   'Authorization' => "Token token=\"#{ENV['LT_API_KEY']}\"" },
        query: { 'city_from' => 'Moscow',
                  'country_to' => 'TR',
                  'start_date' => @requested_date_fan,
                  'end_date' => @requested_date_fan}).
      to_return(status: 200, body: '{"2014-12-30":[7]}')

end

When(/^I enter '(.+)' in '(.+)' field$/) do |value, field_name|
  @params[field_name.downcase.to_sym] = value
  fill_in field_name, with: value
end

Then(/^I see confirmation page$/) do
  expect(page).to have_content(
    "The message with the list of countries \
    avaliable on #{@requested_date} for #{@requested_nights} nights \
    have been sent to email: #{@params[:email]}")
end

Then(/^I receive email with proper countries$/) do
  # binding.pry
  @available_countries.each do |country|
    expect(ActionMailer::Base.deliveries.last.body.encoded).to match(country)
  end
end
