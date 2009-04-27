class AddEmergencyToChannel < ActiveRecord::Migration
  def self.up
    add_column :channels, :emergency, :boolean, :default => false
  end

  def self.down
    remove_column :channels, :emergency
  end
end
