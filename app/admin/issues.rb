# encoding: utf-8

ActiveAdmin.register Issue do
  menu label: "Номера"

  filter :name
  filter :number
  filter :issued_at

  index do
    column :id
    column :number
    column :name
    column :cover do |issue|
      image_tag(issue.cover.thumb)
    end
    column :issued_at
    column :created_at
    column :updated_at

    default_actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :number
      f.input :issued_at
      f.input :cover
    end

    f.actions
  end
end
