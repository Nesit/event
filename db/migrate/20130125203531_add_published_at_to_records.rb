class AddPublishedAtToRecords < ActiveRecord::Migration
  def change
    add_column :articles, :published_at, :datetime
    add_column :polls, :published_at, :datetime
    
    add_index :articles, :published_at
    add_index :polls, :published_at
  end
end
