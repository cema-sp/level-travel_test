class WelcomeController < ApplicationController
  INDEX_PAGE_MD_FILE = 'README.md'

  def index
    # File.read(Rails.root.join(INDEX_PAGE_MD_FILE))
    kramdown_document = 
      Kramdown::Document.new(
        File.read(
          Rails.root.join(INDEX_PAGE_MD_FILE)))
    render inline: kramdown_document.to_html
  end
end
