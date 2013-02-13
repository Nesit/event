# encoding: utf-8

module MenuHelper
  require 'uri'

  def read_menu_item(url)
    uri = URI.parse(url)
    result = nil

    categories = [
      'company', 'event', 'interview', 'news',
      'overview', 'report', 'trip', 'detail'].map(&:pluralize)
    categories.push 'tv'

    page_regex = /pages\/(.*)/
    article_regex = /(#{categories.join('|')})\/(.*)/
    category_regex = /(#{categories.join('|')})/
    poll_regex = /polls\/(.*)/
    polls_regex = /polls/

    case uri.path
    when page_regex
      match = page_regex.match(uri.path)
      page = Page.find(match[1])
      result = {
        'kind' => 'Page',
        'data' => page.id,
        'title' => page.name,
      }
    when article_regex
      match = article_regex.match(uri.path)
      article = Article.find(match[2])
      result = {
        'kind' => 'Article',
        'data' => page.id,
        'title' => article.title,
      }
    when category_regex
      match = category_regex.match(uri.path)
      name = match[1]
      type = "#{name.singularize}_article".camelcase
      result = {
        'kind' => 'ArticleCategory',
        'data' => type,
        'title' => I18n.t("articles.category.#{type}"),
      }
    when poll_regex
      match = poll_regex.match(uri.path)
      poll = Poll.find(match[1])
      result = {
        'kind' => 'Poll',
        'data' => poll.id,
        'title' => poll.title,
      }
    when polls_regex = /polls/
      result = {
        'kind' => 'Polls',
        'title' => "Мнения",
      }
    else
      result = {
        'kind' => 'Special',
        'data' => url,
      }
    end

    result
  end

  def url_from_menu_item(item)
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
    when 'Poll'
      poll = Poll.find(item['data'])
      url_for(poll)
    when 'Polls'
      polls_path
    when 'Special'
      item['data']
    end
  end

  def item_for_form(item)
    {
      item: item,
      link: url_from_menu_item(item),
    }
  end

  def current_menu_item?(item)
    got = URI.parse(request.url).path
    expected = URI.parse(url_from_menu_item(item)).path
    got == expected
  end
end