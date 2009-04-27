class AddStatusToOutbox < ActiveRecord::Migration
  def self.up
    add_column :outbox, :status, :string    
  end

  def self.down
    drop_column :outbox, :status
  end
end
