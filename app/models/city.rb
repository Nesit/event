class City < ActiveRecord::Base
  validates :name, :country_cd, presence: true

  attr_accessible :name, :country

  has_many :users

  as_enum :country,
    russia: 0, belarus: 1, ukraine: 2, moldavia: 3,
    poland: 4, lithuania: 5, latvia: 6, khazakhstan: 7
end
