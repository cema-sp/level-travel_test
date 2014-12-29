require 'rails_helper'

RSpec.describe 'first_test/index', type: :view do
  let(:from_cities) do
    [['Москва','Moscow'],
    ['Кингстон', 'Kingston'],
    ['Пало Альто', 'Palo Alto']]
  end

  let(:from_cities_options) { from_cities.map{ |el| el[0] } }

  let(:to_countries) do
    [['Россия', 'RU'],
    ['Ямайка', 'JM'],
    ['США', 'US']]
  end

  let(:to_countries_options) { to_countries.map{ |el| el[0] } }

  before do
    assign(:from_cities, from_cities)
    assign(:to_countries, to_countries)
    render
  end

  subject { rendered }

  it { should have_select('from_city', options: from_cities_options) }

  it { should have_select('to_country', options: to_countries_options) }

  it { should have_selector("form[method=\"post\"][action=\"#{first_path}\"]") }

  it { should have_selector("input[type=\"submit\"][value=\"Показать\"]") }
end
