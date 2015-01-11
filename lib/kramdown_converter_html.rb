module Kramdown
  module Converter
    class Html
      alias_method :convert_img_original, :convert_img
      def convert_img(el, indent)
        el.attr["src"].sub!("app/assets/images/", "assets/")
        convert_img_original(el, indent)
      end
    end
  end
end
