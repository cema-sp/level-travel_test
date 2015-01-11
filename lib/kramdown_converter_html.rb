
module Kramdown
  module Converter
    class Html
      alias_method :convert_img_original, :convert_img
      def convert_img(el, indent)
        extend ActionView::Helpers::AssetUrlHelper
        # binding.pry
        if el.attr["src"].include?('app/assets/images/') &&
          (matching = el.attr["src"].match(/\w+\.\w+$/))

          el.attr["src"] = image_path(matching[0])
        end
        convert_img_original(el, indent)
      end
    end
  end
end
