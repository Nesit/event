# -*- coding: utf-8 -*-

require 'open-uri'
require 'nokogiri'

class SiteConfig < ActiveRecord::Base
  belongs_to :actual_article, class_name: 'Article'

  store :bottom_menu
  store :top_menu
  store :weather
  attr_accessible :bottom_menu, :top_menu, :weather

  attr_accessible :actual_article_id, :actual_article_description,
                  :article_list_banner_after, :article_list_banner_body

  def name
    'Настройки'
  end

  def load_weather_data
    moscow_id = load_moscow_city_id
    content = open("http://export.yandex.ru/weather-ng/forecasts/#{moscow_id}.xml").read
    doc = Nokogiri::XML(content, nil, 'utf-8')
    items = []
    (0..8).each do |n|
      item = {}
      date = Date.today + n.days
      
      day_elt = doc.search("day[@date=\"#{date.to_s}\"]").first
      tempr = day_elt.search("*[@type=day]").search('temperature-data/avg').first.text()
      icon_name = day_elt.search("*[@type=day]").search('image-v3').first.text()
      
      item['weekday'] = Russian.strftime(date, "%a")
      item['month_day'] = Russian.strftime(date, "%d/%m")
      item['temperature'] = tempr
      item['icon_name'] = icon_name

      items.push item
    rescue
      # just skip element
    end
    # take only 7 elements, even if we take 8
    # this ugly hack needed, because of timezone problem
    # on production server
    self.weather['items'] = items[0..7]
  end

  private

  def load_moscow_city_id
    content = open("http://pogoda.yandex.ru/static/cities.xml").read
    doc = Nokogiri::XML(content, nil, 'utf-8')
    doc.xpath('//cities/country[@name="Россия"]')
    moscow_elt = doc.xpath('//cities/country[@name="Россия"]/city[text()="Москва"]').first
    moscow_elt.attr('id')
  end
end
