class AddDelayToGateway < ActiveRecord::Migration
  def self.up
    add_column :gateways, :delay, :integer, :default => 60
  end

  def self.down
    remove_column :gateways, :delay
  end
end
