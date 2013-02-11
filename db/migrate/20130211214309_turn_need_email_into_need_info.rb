class TurnNeedEmailIntoNeedInfo < ActiveRecord::Migration
  def up
    User.all.each do |user|
      if user.state == 'need_email'
        user.state = 'need_info'
        user.save!
      end
    end
  end

  def down
  end
end
