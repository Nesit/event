# encoding: utf-8

# load app/models/article.rb needed,
# because Rails can't detect where placed code
# for CompanyArticle, EventArticle and others, because they're
# generated dynamically.
require Rails.root.join('app/models/article')

%w[ CompanyArticle EventArticle InterviewArticle
  NewsArticle OverviewArticle ReportArticle
  TripArticle TvArticle
].each do |klass|
  ActiveAdmin.register klass.constantize do
    menu parent: "Статьи", label: I18n.t("active_admin.#{klass}")

    filter :title
    filter :closed
    filter :target_at if klass == "EventArticle"
    filter :created_at
    filter :updated_at

    index do
      column :id
      column :title
      column :closed
      column :head_image do |article|
        image_tag(article.head_image.list_thumb)
      end

      column :galleries do |article|
        link_to "Галлереи", admin_article_galleries_path('q[article_id_eq]' => article.id)
      end

      column :target_at if klass == "EventArticle"
      column :created_at
      column :updated_at

      default_actions
    end

    form partial: "articles/admin_form"
  end
end