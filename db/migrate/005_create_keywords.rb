class CreateKeywords < ActiveRecord::Migration
  def self.up
    create_table :keywords do |t|
      t.string :word, :null => false
      t.text :description
      t.string :language, :null => false
      t.integer :channel_id, :null => false
      t.timestamps
    end

    add_index :keywords, [:word, :language]
    add_index :keywords, :channel_id
  end

  def self.down
    drop_table :keywords
  end
end
