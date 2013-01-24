# encoding: utf-8

ActiveAdmin.register ArticleGallery do
  menu false
  actions :all, except: [:new]

  filter :title

  index do
    column :id
    column :title
    
    column :first_image do |gallery|
      if image = gallery.images.first
        image_tag(image.source)
      end
    end

    column :images do |gallery|
      link_to "Изображения", admin_article_body_images_path('q[article_gallery_id_eq]' => gallery.id)
    end

    column :created_at
    column :updated_at

    default_actions
  end

  form partial: "article_galleries/admin_form"
end