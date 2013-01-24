module MenuHelper
  def active_menu_category?(klass)
    controller_name == 'articles' and params[:type] == klass.name
  end

  def active_menu_polls?
    controller_name == 'polls'
  end
end