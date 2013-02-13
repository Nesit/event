# encoding: utf-8

class AddTopMenuToSiteConfigs < ActiveRecord::Migration
  def change
    add_column :site_configs, :top_menu, :text
    source = <<-YAML
    items:
    - kind: ArticleCategory
      data: NewsArticle
      title: "Новости"
    - kind: ArticleCategory
      data: EventArticle
      title: "Афиша"
    - kind: ArticleCategory
      data: InterviewArticle
      title: "Интервью"
    - kind: ArticleCategory
      data: CompanyArticle
      title: "Компании"
    - kind: ArticleCategory
      data: OverviewArticle
      title: "Обзоры"
    - kind: ArticleCategory
      data: DetailArticle
      title: "Детали"
    - kind: ArticleCategory
      data: TripArticle
      title: "Опыт"
    - kind: ArticleCategory
      data: ReportArticle
      title: "Report"
    - kind: ArticleCategory
      data: TvArticle
      title: "TV"
    - kind: Polls
      title: "Мнения"
    YAML
    if config = SiteConfig.first
      config.top_menu = YAML.load(source)
      config.save!
    end
  end
end
