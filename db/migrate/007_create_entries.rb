class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.string :title
      t.string :summary
      t.string :link
      t.string :author
      t.string :contributor
      t.text :description
      t.text :content
      t.string :category
      t.string :uuid
      t.datetime :published_at
      t.datetime :updated_at
      t.datetime :expires_at
      t.integer :channel_id, :null => false
      t.timestamps
    end
    
    add_index :entries, :channel_id
    add_index :entries, [:channel_id, :updated_at]
  end

  def self.down
    drop_table :entries
  end
end
