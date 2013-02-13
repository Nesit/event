module ApplicationHelper
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
      config.bottom_menu['items'].map do |item|
        case item['kind']
        when 'Page'
          page = Page.find(item['id'].to_i)
          link_to page.name, page
        else
          ""
        end
      end.join.html_safe
    else
      Page.all.map do |page|
        link_to page.name, page
      end.join.html_safe
    end
  end
end
