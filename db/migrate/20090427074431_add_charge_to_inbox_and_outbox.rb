class AddChargeToInboxAndOutbox < ActiveRecord::Migration
  def self.up
    add_column :outbox, :charge, :float, :default => 0
    add_column :inbox, :charge, :float, :default => 0    
  end

  def self.down
    drop_column :outbox, :charge
    drop_column :inbox, :status
  end
end
