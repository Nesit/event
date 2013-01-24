# encoding: utf-8

ActiveAdmin.register Page do
  menu label: "Стат. страницы"

  filter :name

  index do
    column :id
    column :name
    column :created_at
    column :updated_at

    default_actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :body, as: :html_editor
    end

    f.actions
  end
end
