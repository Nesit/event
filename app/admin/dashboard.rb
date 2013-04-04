# encoding: utf-8

ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    

    columns do
      column do
        panel "Последние комментарии" do
          ul do
            h2 link_to "Все комментарии", admin_content_comments_path
            Comment.newer.first(10).map do |comment|
              li link_to(comment.body, admin_content_comment_path(comment))
            end
          end
        end
      end

      column do
        div :class => "blank_slate_container", :id => "dashboard_default_message" do
          span :class => "blank_slate" do
            span "Добро пожаловать в панель администратора."
          end
        end
      end
    end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
