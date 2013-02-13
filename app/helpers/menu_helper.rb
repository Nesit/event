module MenuHelper
  require 'uri'

  def read_menu_item(url)
    uri = URI.parse(url)
    result = nil

    categories = [
      'company', 'event', 'interview', 'news',
      'overview', 'report', 'trip', 'detail'].map(&:pluralize)
    categories.push 'tv'

    article_regex = /(#{categories.join('|')})\/(.*)/
    category_regex = /(#{categories.join('|')})/
    page_regex = /pages\/(.*)/
    case uri.path
    when page_regex
      match = page_regex.match(uri.path)
      page = Page.find(match[1])
      result = {
        kind: 'Page',
        data: page.id,
        title: page.name,
      }
    when article_regex
      match = article_regex.match(uri.path)
      article = Article.find(match[2])
      result = {
        kind: 'Article',
        data: page.id,
        title: article.title,
      }
    when category_regex
      match = category_regex.match(uri.path)
      name = match[1]
      type = "#{name.singularize}_article".camelcase
      result = {
        kind: 'ArticleCategory',
        data: type,
        title: I18n.t("articles.category.#{type}"),
      }
    else
      result = {
        kind: 'Special',
        data: url,
      }
    end

    result
  end

  def url_from_menu_item(item)
    # force to use strings for keys, not symbols,
    # to make all consistent
    item = Hash[item.map{ |k, v| [k.to_s, v] }]

    case item['kind']
    when 'Page'
      page = Page.find(item['data'])
      url_for(page)
    when 'Article'
      article = Article.find(item['data'])
      url_for(article)
    when 'ArticleCategory'
      sym = item['data'].underscore.pluralize
      send("#{sym}_path")
    when 'Special'
      item['data']
    end
  end

  def link_from_menu_item(item)
    link_to item['title'], url_from_menu_item(item)
  end

  def item_for_form(item)
    {
      item: item,
      link: url_from_menu_item(item),
    }
  end

  def active_menu_category?(klass)
    controller_name == 'articles' and params[:type] == klass.name
  end

  def active_menu_polls?
    controller_name == 'polls'
  end
end