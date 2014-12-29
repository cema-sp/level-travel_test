module ApplicationHelper
  def menu_item_class(path)
    current_page?(path) ? 'item active' : 'item'
  end
end
