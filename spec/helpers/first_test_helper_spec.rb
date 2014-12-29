require 'rails_helper'

RSpec.describe FirstTestHelper, type: :helper do
  describe 'cell_bg_color(max, value)' do
    let(:max) { 10 }
    let(:value) { 4 }
    let(:color) { 'background-color: rgb(255, 204, 0);' }

    it "returns 'background-color: @color;'" do
      expect(cell_bg_color(max, value)).to eq(color)
    end
  end
end
