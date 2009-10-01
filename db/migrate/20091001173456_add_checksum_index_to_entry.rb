class AddChecksumIndexToEntry < ActiveRecord::Migration
  def self.up
    add_index :entries, [:checksum]
  end

  def self.down
  end
end
