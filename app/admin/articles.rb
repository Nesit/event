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

    actions :all, :except => [:show]

    controller do
      def show
        redirect_to(eval("edit_admin_#{resource.class.name.underscore}_path(resource)")) and return
      end
    end


    filter :title
    filter :closed
    filter :target_at if klass == "EventArticle"
    filter :published_at
    filter :created_at
    filter :updated_at

    index do
      column :id
      column :title do |resource|
        truncate(resource.title)
      end
      column :closed do |resource|
        resource.closed? ? 'Да' : 'Нет'
      end
      column :head_image do |article|
        image_tag(article.head_image.thumb)
      end

      column :galleries do |article|
        link_to "Галлереи", admin_article_galleries_path('q[article_id_eq]' => article.id)
      end
      column :target_at do |resource|
        resource.target_at.to_s(:tiny)
      end if klass == "EventArticle"
      column :published_at do |resource|
        resource.published_at.to_s(:tiny)
      end
      default_actions
    end

    form partial: "articles/admin_form"
  end
end
