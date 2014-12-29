require 'rails_helper'
RSpec.describe ApplicationHelper, type: :helper do
  describe '#menu_item_class(path)' do
    let(:path) { '/my/path' }

    before do
      allow(self)
        .to receive(:current_page?)
        .with(path)
        .and_return(true)
    end

    it "returns 'item active'" do
      expect(menu_item_class(path)).to eq('item active')
    end
  end
end
