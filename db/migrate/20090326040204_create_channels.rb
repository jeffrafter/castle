class CreateChannels < ActiveRecord::Migration
  def self.up
    create_table :channels do |t|
      t.string :title
      t.string :subtitle
      t.string :keywords
      t.text :description
      t.datetime :modified_at
      t.boolean :active, :default => true, :null => false
      t.integer :region_id, :null => false
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :channels, [:region_id, :active, :modified_at]
  end

  def self.down
    drop_table :channels
  end
end
