require 'rails_helper'

RSpec.describe 'welcome/index', type: :view do
  let(:h1_text) { 'Header' }
  let(:file_content_html) { "<h1>#{h1_text}</h1>" }

  before do
    assign(:file_content_html, file_content_html)
  end

  describe 'after render' do
    before { render }
    subject { rendered }
    it { should have_xpath("//h1[text()=\"#{h1_text}\"]") }
  end
end
