class CreatePartnerNewsletters < ActiveRecord::Migration
  def change
    create_table :partner_newsletters do |t|
      t.string :title, null: false
      t.string :state
      t.datetime :started_at
      t.text :text
      t.timestamps
    end
  end
end
