class AddLastEmailAtToUsers < ActiveRecord::Migration
  def up
    add_column :users, :last_email_comment, :datetime
    add_column :users, :last_email_article, :datetime
  end

  def down
    remove_column :user, :last_email_comment
    remove_column :user, :last_email_article
  end
end
