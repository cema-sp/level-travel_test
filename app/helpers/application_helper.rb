module ApplicationHelper
  def menu_item_class(path)
    (request.path == path) ? 'item active' : 'item'
  end
end
