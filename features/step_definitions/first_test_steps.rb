# require "#{File.dirname(__FILE__)}/../../support/env.rb"
# require "#{File.dirname(__FILE__)}/../../step_definitions/common_steps.rb"

Given(/^It is '(\d+)\-(\d+)\-(\d+)'$/) do |year, month, day|
  allow(Date)
    .to receive(:today)
    .and_return(Date.parse("#{year}-#{month}-#{day}"))

  @start_date = Date.today.strftime('%-d.%-m.%Y')
  @end_date = (Date.today + 31).strftime('%-d.%-m.%Y')
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
