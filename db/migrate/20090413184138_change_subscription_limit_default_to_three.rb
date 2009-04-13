class ChangeSubscriptionLimitDefaultToThree < ActiveRecord::Migration
  def self.up
    remove_column :subscriptions, :number_per_day
    add_column :subscriptions, :number_per_day, :integer, :default => 3
  end

  def self.down
  end
end
