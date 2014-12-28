require 'rails_helper'
# require 'Date'

RSpec.describe "first_test/show", :type => :view do
  let(:start_date) { '1.12.2014' }
  let(:end_date) { '31.12.2014' }
  let(:from_city) { 'Moscow' }
  let(:to_country) { 'EG' }
  let(:table_data) do
    [[{'1' => ['5','8']},'2', '3','4','5','6','7'],
    [{'8' => ['5','8']},'9', '10','11','12','13','14'],
    [{'15' => ['5','8']},'16', '17','18','19','20','21'],
    [{'22' => ['5','8']},'23', '24','25','26','27','28'],
    [{'29' => ['5','8']},'30', '31',nil,nil,nil,nil]]
  end

  before do
    assign(:start_date, start_date)
    assign(:end_date, end_date)
    assign(:from_city, from_city)
    assign(:to_country, to_country)
    assign(:table_data, table_data)
    render
  end

  subject { rendered }

  it { should_not be_nil }

  it 'has proper header' do
    should have_content(
      "Period: #{start_date} - #{end_date}, 
      From: #{from_city}, 
      To: #{to_country}"
    )
  end

  it 'has proper table header' do
    %w{ Пн Вт Ср Чт Пт Сб Вс }.each do |dow|
      should have_selector('table thead th', text: dow)
    end
  end

  it 'has proper table body' do
    table_data.each_with_index do |table_row, row_index|
      table_row.each_with_index do |table_cell, cell_index|
        case table_cell
        when Hash
          should have_xpath(
            "//table/tbody\
            /tr[#{row_index + 1}]\
            /td[#{cell_index + 1}]\
            [strong/text()=\"#{table_cell.first[0]}\"]\
            [p/text()=\"#{table_cell.first[1].join(', ')}\"]")
        when String
          should have_xpath(
            "//table/tbody\
            /tr[#{row_index + 1}]\
            /td[#{cell_index + 1}]\
            /strong[text()=\"#{table_cell}\"]")
        end
      end
    end
  end
end
