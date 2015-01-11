require 'rails_helper'
require Rails.root.join('lib/kramdown_converter_html')

RSpec.describe Kramdown::Converter::Html do
  before { extend ActionView::Helpers::AssetUrlHelper }

  let(:img_name) { 'img.png' }
  let(:img_asset_path) { image_path(img_name) }
  let(:img_md) { "![Image](app/assets/images/#{img_name})" }
  let(:img_html) { "<img src=\"#{img_asset_path}\" alt=\"Image\" />" }

  describe '#convert_img(el, indent)' do
    it 'uses custom src processing' do
      # binding.pry
      expect(Kramdown::Document.new(img_md).to_html).to match(img_html)
    end
  end
end
