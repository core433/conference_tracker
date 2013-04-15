class ChangeEventsStringToText < ActiveRecord::Migration
  def up
  	change_column :events, :name, :text, :limit => nil
  	change_column :events, :city, :text, :limit => nil
  	change_column :events, :description, :text, :limit => nil
  	change_column :events, :ticket_url, :text, :limit => nil
  	change_column :events, :ticket_info, :text, :limit => nil
  	change_column :events, :organization_description, :text, :limit => nil
  	change_column :events, :contact, :text, :limit => nil
  	change_column :events, :venue, :text, :limit => nil
  	change_column :events, :venue_directions, :text, :limit => nil
  end

  def down
  end
end
