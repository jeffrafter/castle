class CreateRegions < ActiveRecord::Migration
  def self.up
    create_table :regions do |t|
      t.string :name, :null => false
      t.string :country, :null => false
      t.string :language, :null => false
      t.boolean :active, :default => true, :null => false

      t.timestamps
    end

    add_index :regions, [:name]
    add_index :regions, [:country]
  end

  def self.down
    drop_table :regions
  end
end
