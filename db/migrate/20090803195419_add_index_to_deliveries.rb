class AddIndexToDeliveries < ActiveRecord::Migration
  def self.up
    add_index :deliveries, [:entry_id, :channel_id, :user_id, :created_at]
    add_index :deliveries, :user_id
    add_index :deliveries, :channel_id
    add_index :deliveries, :entry_id
    add_index :deliveries, :created_at
  end

  def self.down
  end
end
