class AddIdentifierToOutbox < ActiveRecord::Migration
  def self.up
    add_column :outbox, :identifier, :integer
    add_index :outbox, :identifier
  end

  def self.down
    remove_column :outbox, :identifier
    drop_index :outbox, :identifier
  end
end
