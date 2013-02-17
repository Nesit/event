# encoding: utf-8

ActiveAdmin.register ::Comment, as: "ContentComment" do
  menu label: "Комментарии"

  batch_action :remove_by_admin do |selection|
    ::Comment.find(selection).each do |comment|
      comment.state = 'removed_by_admin'
      comment.save!
    end
    redirect_to admin_content_comments_path
  end

  scope :active, default: true
  scope :removed_by_owner
  scope :removed_by_admin

  index do                            
    selectable_column
    column :body
    column :author
    column :topic
    column :edit_count do |comment|
      comment.texts_versions.count
    end
    default_actions
  end

  form partial: 'comments/admin_form'
end
