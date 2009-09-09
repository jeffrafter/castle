class CreateSubscriptionsAndDeliveries < ActiveRecord::Migration
  def self.up
    create_table :subscriptions, :force => true do |t|
      t.integer :user_id
      t.integer :channel_id
      t.integer :number_per_day, :default => 5
      t.boolean :want_all, :default => false
      t.datetime :deleted_at      
      t.timestamps
    end

    create_table :deliveries, :force => true do |t|
      t.integer :entry_id
      t.integer :channel_id
      t.integer :user_id
      t.boolean :read, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :subscriptions
    drop_table :deliveries
  end
end
