
module Kramdown
  module Converter
    class Html
      alias_method :convert_img_original, :convert_img
      def convert_img(el, indent)
        matching = el.attr["src"].match(/app\/assets\/images\/(.*\w+\.\w+$)/)
        if (matching)
          el.attr["src"] =
            ActionController::Base.helpers.asset_path(matching[1])
        end
        convert_img_original(el, indent)
      end
    end
  end
end
