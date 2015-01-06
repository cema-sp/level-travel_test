require 'rails_helper'

RSpec.describe SecondTestMailer, type: :mailer do
  describe 'countries_email' do
    let(:date) { '2014-12-30' }
    let(:nights) { '7' }
    let(:email) { 's.a.pisarev@gmail.com' }
    let(:countries) { %w(Россия Египет Турция) }

    let(:countries_email) do
      described_class.countries_email(email, date, nights, countries)
    end

    subject { countries_email }

    describe 'parameters' do
      its(:subject) do
        should match(date)
        should match(nights)
      end
      its(:to) { should eq([email]) }
      its(:from) { should eq(['s.a.pisarev@gmail.com']) }
    end

    describe 'body' do
      subject { countries_email.text_part.body.decoded }

      it 'matches each country' do
        countries.each do |country|
          should match(country)
        end
      end

      it { should match(date) }
      it { should match(nights) }
    end
  end
end
