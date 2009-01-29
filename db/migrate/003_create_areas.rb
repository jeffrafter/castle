class CreateAreas < ActiveRecord::Migration
  def self.up
    create_table :areas do |t|
      t.string :name, :null => false
      t.integer :country_code, :null => false
      t.integer :area_code, :null => false
      t.integer :region_id, :null => false
      t.timestamps
    end

    add_index :areas, [:country_code, :area_code]
    add_index :areas, :name
    add_index :areas, :region_id
  end

  def self.down
    drop_table :areas
  end
end
