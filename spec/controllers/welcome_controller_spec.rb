require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  describe 'GET index' do
    let(:file_name) { 'README.md' }
    let(:file_path) { Rails.root.join(file_name) }
    let(:file_content) { 'MD text' }
    let(:file_content_html) { Kramdown::Document.new(file_content).to_html }

    before do
      allow(File)
        .to receive(:read)
        .with(file_path)
        .and_return(file_content)
    end

    describe 'on GET' do
      after { get :index }

      it 'reads file' do
        expect(File)
          .to receive(:read)
          .with(file_path)
          .and_return(file_content)
      end

      it 'calls Kramdown::Document#new' do
        expect(Kramdown::Document)
          .to receive(:new)
          .with(file_content)
          .and_call_original
      end
    end

    describe 'after GET' do
      before { get :index }
      subject { response }

      it { should be_success }
      it { should render_template('index') }

      describe 'assignments:' do
        it "assigns file content as '@file_content_html'" do
          expect(assigns(:file_content_html)).to eq(file_content_html)
        end
      end
    end
  end
end
