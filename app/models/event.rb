class Event < ActiveRecord::Base
  attr_accessible :city, :name, :time, :time_end, :event_type, :field, :host, 
  :description, :cost, :ticket_url, :ticket_info, :organization_description,
  :contact, :contact_phone, :venue, :venue_addr, :venue_directions

  validates :name, presence: true, length: { maximum: 300 }
  validates :city, presence: true, length: { maximum: 200 }

end
