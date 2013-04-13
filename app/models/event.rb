class Event < ActiveRecord::Base
  attr_accessible :city, :name, :time

  validates :name, presence: true, length: { maximum: 50 }
  validates :city, presence: true, length: { maximum: 30 }
end
