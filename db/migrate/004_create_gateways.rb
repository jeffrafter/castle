class CreateGateways < ActiveRecord::Migration
  def self.up
    create_table :gateways do |t|
      t.string   :number
      t.integer  :short_code
      t.integer  :country_code
      t.integer  :area_code
      t.boolean  :active
      t.string   :api_key, :limit => 128
      t.datetime :api_key_expires_at
      t.integer  :region_id, :null => false
      t.string   :locale, :null => false, :default => 'en'
      t.timestamps
    end

    add_index :gateways, [:country_code, :area_code]
    add_index :gateways, [:api_key, :api_key_expires_at]
    add_index :gateways, :short_code
    add_index :gateways, :number
    add_index :gateways, :region_id
  end

  def self.down
    drop_table :gateways
  end
end
