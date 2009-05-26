class AddDelayToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :delay, :integer, :default => 60
  end

  def self.down
    remove_column :users, :delay
  end
end
