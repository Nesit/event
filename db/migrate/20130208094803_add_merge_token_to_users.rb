class AddMergeTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :merge_token, :string
    add_column :users, :merge_email, :string
    add_column :users, :merge_token_expires_at:, :datetime
    add_index :users, :merge_token
  end
end
