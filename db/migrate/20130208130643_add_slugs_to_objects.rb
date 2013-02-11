class AddSlugsToObjects < ActiveRecord::Migration
  def change
    [:articles, :polls, :pages].each do |tab_sym|
      add_column tab_sym, :slug, :string
      add_index tab_sym, :slug, unique: true
    end
  end
end
