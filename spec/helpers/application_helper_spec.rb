require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#menu_item_class(path)' do
    let(:path) { '/my/path' }

    context 'on current page' do
      before do
        allow_message_expectations_on_nil
        allow(request)
          .to receive(:path)
          .and_return(path)
      end

      it "returns 'item active'" do
        expect(menu_item_class(path)).to eq('item active')
      end
    end

    context 'not on current page' do
      before do
        allow_message_expectations_on_nil
        allow(request)
          .to receive(:path)
          .and_return(path + '/whoops')
      end

      it "returns 'item'" do
        expect(menu_item_class(path)).to eq('item')
      end
    end
  end
end
