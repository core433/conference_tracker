class AddDetailsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :time_end, :datetime
    add_column :events, :type, :string
    add_column :events, :field, :string
    add_column :events, :host, :string
    add_column :events, :description, :string
    add_column :events, :cost, :string
    add_column :events, :ticket_url, :string
    add_column :events, :ticket_info, :string
    add_column :events, :organization_description, :string
    add_column :events, :contact, :string
    add_column :events, :contact_phone, :string
    add_column :events, :venue, :string
    add_column :events, :venue_addr, :string
    add_column :events, :venue_directions, :string
  end
end
