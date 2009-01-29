class CreateChannels < ActiveRecord::Migration
  def self.up
    create_table :channels do |t|
      t.string :title
      t.string :subtitle
      t.string :link, :null => false
      t.text :description
      t.string :author
      t.integer :interval
      t.datetime :updated_at
      t.boolean :active, :default => true, :null => false
      t.integer :region_id, :null => false
      t.timestamps
    end

    add_index :channels, [:region_id, :active]
    add_index :channels, :link
  end

  def self.down
    drop_table :channels
  end
end
