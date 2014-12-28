require 'rails_helper'

RSpec.describe "second_test/send_message", :type => :view do
  let(:date) { '2014-12-30' }
  let(:nights) { '7' }
  let(:email) { 's.a.pisarev@gmail.com' }

  before do
    assign(:date, date)
    assign(:nights, nights)
    assign(:email, email)
    render
  end

  subject { rendered }

  it do
    should have_content(
      "The message with the list of countries \
      avaliable on #{date} for #{nights} nights \
      have been sent to email: #{email}")
  end
end
