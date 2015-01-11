require Rails.root.join('lib/kramdown_converter_html')

class WelcomeController < ApplicationController
  INDEX_PAGE_MD_FILE = 'README.md'

  def index
    @file_content_html = 
      Kramdown::Document.new(
        File.read(
          Rails.root.join(INDEX_PAGE_MD_FILE))
      ).to_html
  end
end
