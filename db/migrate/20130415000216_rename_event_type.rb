class RenameEventType < ActiveRecord::Migration
  def up
  	rename_column :events, :type, :event_type
  end

  def down
  end
end
