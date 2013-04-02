# encoding: utf-8

ActiveAdmin.register Issue do
  menu label: "Номера"

  filter :name
  filter :number
  filter :issued_at

  index do
    id_column
    column :number
    column :name
    column :cover do |issue|
      image_tag(issue.cover.thumb)
    end
    %w[issued_at created_at].each do |method|
      column method.to_sym do |resource|
        resource.send(method.to_sym).to_s(:tiny_with_time)
      end
    end


    default_actions
  end

  form partial: 'issues/admin_form'
end
