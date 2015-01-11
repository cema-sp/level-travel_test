require 'rails_helper'
require Rails.root.join('lib/kramdown_converter_html')

RSpec.describe Kramdown::Converter::Html do
  let(:img_md) { '![Image](app/assets/images/img.png)' }
  let(:img_html) { '<img src="assets/img.png" alt="Image" />' }

  describe '#convert_img(el, indent)' do
    it 'uses custom src processing' do
      expect(Kramdown::Document.new(img_md).to_html).to match(img_html)
    end
  end
end
