class AddSystemToChannel < ActiveRecord::Migration
  def self.up
    add_column :channels, :system, :boolean, :default => false
  end

  def self.down
    remove_column :channels, :system
  end
end
