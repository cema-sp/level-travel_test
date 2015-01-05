require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'menu_item_class(path)' do
    let(:path) { '/correct/path' }

    before do
      allow_message_expectations_on_nil
      allow(request)
        .to receive(:path)
        .and_return(path)
    end

    context 'on correct page' do
      it "returns 'item active'" do
        expect(menu_item_class(path)).to eq('item active')
      end
    end

    context 'not on correct page' do
      let(:another_path) { '/incorrect/path' }

      it "returns 'item'" do
        expect(menu_item_class(another_path)).to eq('item')
      end
    end
  end
end
