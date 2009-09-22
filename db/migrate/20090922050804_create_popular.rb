class CreatePopular < ActiveRecord::Migration
  def self.up
    create_table :popular do |t|
      t.integer :channel_id, :null => false
      t.integer :entry_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :popular
  end
end
