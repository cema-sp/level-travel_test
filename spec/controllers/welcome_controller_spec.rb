require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  describe 'GET index' do
    let(:file_name) { 'README.md' }
    let(:file_path) { Rails.root.join(file_name) }
    let(:file_text) { "MD text" }

    before do
      allow(File)
        .to receive(:read)
        .with(file_path)
        .and_return(file_text)
    end

    describe 'after GET' do
      before { get :index }
      subject { response }

      it { should be_success }
      it { should_not render_template('index') }
      # it { binding pry; should have_xpath("//p[text()=\"#{file_text}\"]") }
    end

    describe 'on GET' do
      after { get :index }

      it 'reads file' do
        expect(File)
          .to receive(:read)
          .with(file_path)
          .and_return(file_text)
      end

      it 'invokes Kramdown::Document#new' do
        expect(Kramdown::Document)
          .to receive(:new)
          .with(file_text)
          .and_call_original
      end
    end
  end
end
