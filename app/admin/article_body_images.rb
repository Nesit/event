# encoding: utf-8

ActiveAdmin.register ArticleBodyImage do
  menu false

  controller do
    def destroy
      image = ArticleBodyImage.find(params[:id])
      gallery = image.article_gallery
      image.delete
      redirect_to edit_admin_article_gallery_path(gallery)
    end
  end

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
