World(LevelTravelApiHelper)

Given(/^It is '(\d+)\-(\d+)\-(\d+)'$/) do |year, month, day|
  allow(Date)
    .to receive(:today)
    .and_return(Date.parse("#{year}-#{month}-#{day}"))

  @start_date = Date.today.strftime('%-d.%-m.%Y')
  @end_date = (Date.today + 31).strftime('%-d.%-m.%Y')
end

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

Given(/^nights for selected country in f&n API response are:$/) do |table|
  fan_response_body_hash = {}
  table.hashes.each do |row|
    fan_response_body_hash[row['Date']] =
      row['Nights'].split(',').map(&:to_i)
  end

  @fan_response =
    Typhoeus::Response.new(code: 200, body: fan_response_body_hash.to_json)
end

When(/^I visit '(.*)' path$/) do |path|
  @params = {}

  visit path
end

When(/^I choose '(.*)\,\s(.*)' from '(.*)' dropdown list$/) do 
  |name, value, list_name|

  @params[list_name.downcase.to_sym] = value
  select name, from: list_name
end

When(/^I click '(.*)' button$/) do |button_name|
  if button_name == 'Показать'
    @fan_request =
      stub_typhoeus_request(
        flights_and_nights_request(
          @params[:from_city],
          @params[:to_country],
          @start_date,
          @end_date),
        @fan_response)
  end

  click_link_or_button button_name
end

Then(/^I see the proper info$/) do
  expect(page).to have_content("#{@start_date} - #{@end_date}")
  expect(page).to have_content(@params[:from_city])
  expect(page).to have_content(@params[:to_country])
end

Then(/^I see the proper calendar table:$/) do |table|
  @table_data = []
  tmp_row = []

  table.hashes.each do |table_row|
    %w(Mo Tu We Th Fr Sa Su).each do |wday|
      if (parsed = /(\d+)\s\((.*)\)/.match(table_row[wday]))
        tmp_row << { parsed[1] => parsed[2].split(',').map(&:to_i) }
      else
        tmp_row << (table_row[wday].empty? ? nil : table_row[wday])
      end
    end
    @table_data << tmp_row.clone
    tmp_row.clear
  end

  step 'with proper thead'
  step 'with proper tbody'
end

Then(/with proper thead/) do
  %w(Пн Вт Ср Чт Пт Сб Вс).each do |dow|
    expect(page).to have_selector('table thead th', text: dow)
  end
end

Then(/with proper tbody/) do
  @table_data.each_with_index do |table_row, row_index|
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

Given(/^avaliable countries for '(.+)' and '(\d+)' nights are:$/) do
  |date, nights, table|

  @available_countries = table.hashes.map { |row| row['Country'] }
  @requested_date = date
  @requested_date_fan = Date.parse(@requested_date).strftime('%d.%m.%Y')
  @requested_nights = nights
  ActionMailer::Base.deliveries = []

  # @countries_response = <<-EOF
  # [
  #   {"id":2,
  #   "name_ru":"Russia",
  #   "name_en":"Russia",
  #   "iso2":"RU",
  #   "active":true,
  #   "searchable":true},
  #   {"id":3,
  #   "name_ru":"Egypt",
  #   "name_en":"Egypt",
  #   "iso2":"EG",
  #   "active":true,
  #   "searchable":true},
  #   {"id":4,
  #   "name_ru":"Turkey",
  #   "name_en":"Turkey",
  #   "iso2":"TR",
  #   "active":true,
  #   "searchable":true}
  # ]
  # EOF

  @fan_request_ru =
    stub_request(:get, 'https://level.travel/papi/search/flights_and_nights')
    .with(
        headers: { 'Accept' => 'application/vnd.leveltravel.v2',
                   'Authorization' => "Token token=\"#{ENV['LT_API_KEY']}\"" },
        query: { 'city_from' => 'Moscow',
                 'country_to' => 'RU',
                 'start_date' => @requested_date_fan,
                 'end_date' => @requested_date_fan })
    .to_return(status: 200, body: '{"2014-12-30":[5,6]}')

  @fan_request_eg =
    stub_request(:get, 'https://level.travel/papi/search/flights_and_nights')
    .with(
        headers: { 'Accept' => 'application/vnd.leveltravel.v2',
                   'Authorization' => "Token token=\"#{ENV['LT_API_KEY']}\"" },
        query: { 'city_from' => 'Moscow',
                 'country_to' => 'EG',
                 'start_date' => @requested_date_fan,
                 'end_date' => @requested_date_fan })
    .to_return(status: 200, body: '{"2014-12-30":[5,7]}')

  @fan_request_tr =
    stub_request(:get, 'https://level.travel/papi/search/flights_and_nights')
    .with(
        headers: { 'Accept' => 'application/vnd.leveltravel.v2',
                   'Authorization' => "Token token=\"#{ENV['LT_API_KEY']}\"" },
        query: { 'city_from' => 'Moscow',
                 'country_to' => 'TR',
                 'start_date' => @requested_date_fan,
                 'end_date' => @requested_date_fan })
    .to_return(status: 200, body: '{"2014-12-30":[7]}')
end

When(/^I enter '(.+)' in '(.+)' field$/) do |value, field_name|
  @params[field_name.downcase.to_sym] = value
  fill_in field_name, with: value
end

Then(/^I see confirmation page$/) do
  expect(page).to have_content(@requested_date)
  expect(page).to have_content(@requested_nights)
  expect(page).to have_content(@params[:email])
end

Then(/^I receive email with proper countries$/) do
  @available_countries.each do |country|
    expect(ActionMailer::Base.deliveries.last.text_part.body.decoded).
      to match(country)
  end
end

Then(/^I see the proper index page$/) do
  expect(page).to have_title('For Level-Travel by S. Pisarev')
  expect(page).to have_selector("a[href=\"mailto:s.a.pisarev@gmail.com\"]")
end

Then(/^I see '(.+)' link$/) do |link_path|
  expect(page).to have_selector("a[href=\"#{link_path}\"]")
end
