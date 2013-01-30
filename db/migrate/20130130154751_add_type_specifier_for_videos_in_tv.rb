class AddTypeSpecifierForVideosInTv < ActiveRecord::Migration
  def change
    add_column :articles, :head_video_kind, :string
  end
end
