require 'rails_helper'

RSpec.describe 'first_test/show', type: :view do
  let(:start_date) { '1.12.2014' }
  let(:end_date) { '31.12.2014' }
  let(:from_city) { 'Moscow' }
  let(:to_country) { 'EG' }
  let(:max_nights) { 10 }
  let(:fan_hash) do
    JSON.parse(yaml_fixture('responses')['flights_and_nights'])
  end

  before do
    assign(:start_date, start_date)
    assign(:end_date, end_date)
    assign(:from_city, from_city)
    assign(:to_country, to_country)
    assign(:max_nights, max_nights)
    assign(:fan_hash, fan_hash)
    render
  end

  subject { rendered }

  it 'has proper header' do
    should have_content("#{start_date} - #{end_date}")
    should have_content(from_city)
    should have_content(to_country)
  end
end
