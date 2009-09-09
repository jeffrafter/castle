class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.string :title
      t.string :url
      t.string :author
      t.string :summary
      t.string :message
      t.string :checksum
      t.text :content
      t.string :categories
      t.datetime :published_at
      t.integer :feed_id, :null => false
      t.boolean :processed, :null => false, :default => false
      t.datetime :deleted_at
      t.timestamps
    end
    
    add_index :entries, :feed_id
    add_index :entries, [:feed_id, :published_at]
  end

  def self.down
    drop_table :entries
  end
end
