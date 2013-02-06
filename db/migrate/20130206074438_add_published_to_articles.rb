class AddPublishedToArticles < ActiveRecord::Migration
  def up
    add_column :articles, :published, :boolean, default: true
  end

  def down
    remove_column :articles, :published
  end

end
