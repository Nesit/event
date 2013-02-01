class AddBannedToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.boolean :banned, null: false, default: false
    end
  end
end
