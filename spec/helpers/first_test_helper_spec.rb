require 'rails_helper'

RSpec.describe FirstTestHelper, type: :helper do
  describe 'flights_and_nights_calendar(start_date, end_date, fan_hash)' do
    let(:start_date) { Date.parse('2014-12-05') }
    let(:end_date) { start_date + 31 }
    let(:fan_hash) do
      JSON.parse yaml_fixture('responses')['flights_and_nights']
    end

    subject { flights_and_nights_calendar(start_date, end_date, fan_hash) }

    it 'returns table' do
      should have_selector('table')
    end

    describe 'table' do
      describe 'thead' do
        it 'has all week days names' do
          %w(Пн Вт Ср Чт Пт Сб Вс).each do |dow|
            should have_xpath("//thead/tr/th[text()=\"#{dow}\"]")
          end
        end
      end

      describe 'tbody' do
        it 'has empty cells for previous days' do
          (1...start_date.cwday).each do |n|
            should have_xpath("//tbody/tr[1]/td[#{n}]/strong[text()=\" \"]")
          end
        end

        it 'has cells with dates and nights' do
          (start_date..end_date).each do |date|
            if (nights = fan_hash[date.strftime('%Y-%m-%d')])
              should have_xpath(
                "//tbody\
                /tr/td[#{date.cwday}]\
                [strong/text()=\"#{date.day}\"]\
                [p/text()=\"#{nights.join(', ')}\"]")
            else
              should have_xpath(
                "//tbody\
                /tr/td[#{date.cwday}]\
                /strong[text()=\"#{date.day}\"]")
            end
          end
        end

        it 'has empty cells for next days' do
          (end_date.cwday.next..7).each do |n|
            should have_xpath(
              "//tbody/tr[last()]/td[#{n}]/strong[text()=\" \"]")
          end
        end
      end
    end
  end

  describe 'cell_bg_color(max, value)' do
    let(:max) { 10 }
    let(:value) { 4 }
    let(:color) { 'background-color: rgb(255, 204, 0);' }

    it "returns 'background-color: @color;'" do
      expect(cell_bg_color(max, value)).to eq(color)
    end
  end
end
