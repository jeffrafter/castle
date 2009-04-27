class AddPriorityToOutbox < ActiveRecord::Migration
  def self.up
    add_column :outbox, :priority, :integer, :default => 1    
  end

  def self.down
    remove_column :outbox, :priority
  end
end
