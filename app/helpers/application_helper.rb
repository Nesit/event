module ApplicationHelper
  include MenuHelper # because stupid active admin see only this file

  def display_banners?
    controller_name == 'password_resets' and action_name == 'edit'
  end

  # Just return host with protocol and port like
  # https://sr1.localhost:3000
  def host_path
    "#{request.protocol}#{request.host_with_port}"
  end

  # Return full url path with subdomain
  # Like: https://sr1.localhost:3000/news/1
  def full_url
    "#{host_path}#{request.fullpath}"
  end

  def bottom_menu_tags
    if config = SiteConfig.first and config.bottom_menu['items'].present?
      config.bottom_menu['items'].map { |item| link_to item['title'], url_from_menu_item(item) }
    else
      Page.all.map { |page| link_to page.name, page }
    end.join.html_safe
  end
end
