class CreateFeeds < ActiveRecord::Migration
  def self.up
    create_table :feeds do |t|
      t.integer :channel_id, :null => false
      t.string :feed_url
      t.string :url
      t.string :etag
      t.string :title
      t.string :subtitle
      t.text :description
      t.datetime :last_modified
      t.string :checksum
      t.integer :interval, :default => 10, :null => false
      t.datetime :stale_at
      t.datetime :deleted_at
      t.boolean :active, :default => true, :null => false
      t.timestamps
    end

    add_index :feeds, [:channel_id, :active]
    add_index :feeds, :feed_url
  end

  def self.down
    drop_table :feeds
  end
end
