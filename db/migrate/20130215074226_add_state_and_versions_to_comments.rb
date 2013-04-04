class AddStateAndVersionsToComments < ActiveRecord::Migration
  def change
    add_column :comments, :state, :string
    add_column :comments, :versions, :text

    Comment.reset_column_information
    Comment.all.each do |comment|
      comment.state = 'active'
      comment.save!
    end
  end
end
