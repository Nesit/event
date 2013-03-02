class CreateTemporaryAvatars < ActiveRecord::Migration
  def change
    create_table :temporary_avatars do |t|
      t.string :avatar

      t.timestamps
    end
  end
end
