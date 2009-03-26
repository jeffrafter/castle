class CreateCommands < ActiveRecord::Migration
  def self.up
    create_table :commands do |t|
      t.string :word, :null => false
      t.string :key, :null => false
      t.string :locale, :null => false
      t.timestamps
    end

    add_index :commands, [:word, :key, :locale]
  end

  def self.down
    drop_table :commands
  end
end
