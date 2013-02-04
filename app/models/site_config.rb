# -*- coding: utf-8 -*-
class SiteConfig < ActiveRecord::Base
  belongs_to :actual_article, class_name: 'Article'

  attr_accessible :actual_article_id, :actual_article_description,
                  :article_list_banner_after, :article_list_banner_body

  def name
    'Настройки'
  end
end
