# encoding: utf-8
ActiveAdmin.register ArticleAuthor do
  menu label: "Авторы"

  filter :name

  index do
    column :id
    column :avatar do |author|
      image_tag(author.avatar)
    end
    column :name
    column :created_at
    column :updated_at

    default_actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :avatar
    end

    f.actions
  end
end
