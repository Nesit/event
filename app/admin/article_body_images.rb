# encoding: utf-8

ActiveAdmin.register ArticleBodyImage do
  menu false

  index do
    column :id
    
    column :image do |body_image|
      image_tag(body_image.source)
    end

    column :created_at
    column :updated_at

    default_actions
  end
end
