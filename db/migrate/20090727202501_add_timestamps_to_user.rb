class AddTimestampsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :created_at, :datetime, :default => Time.now
    add_column :users, :updated_at, :datetime, :default => Time.now
  end

  def self.down
    remove_column :users, :created_at
    remove_column :users, :updated_at
  end
end
