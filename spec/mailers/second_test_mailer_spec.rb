require 'rails_helper'

RSpec.describe SecondTestMailer, type: :mailer do
  describe 'countries_email' do
    let(:date) { '2014-12-30' }
    let(:nights) { '7' }
    let(:email) { 's.a.pisarev@gmail.com' }
    let(:countries) { %w(Russia Egypt Turkey) }
    let(:countries_email) { described_class.countries_email(email, date, nights, countries) }

    it 'renders the headers' do
      expect(countries_email.subject).to eq("Countries on #{date} for #{nights} nights")
      expect(countries_email.to).to eq([email])
      expect(countries_email.from).to eq(['s.a.pisarev@gmail.com'])
    end

    it 'renders the body' do
      countries.each do |country|
        expect(countries_email.text_part.body.decoded).to match(country)
      end
    end
  end
end
