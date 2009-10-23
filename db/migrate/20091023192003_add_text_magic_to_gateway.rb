class AddTextMagicToGateway < ActiveRecord::Migration
  def self.up
    add_column :gateways, :textmagic_username, :string
    add_column :gateways, :textmagic_password, :string
  end

  def self.down
    remove_column :gateways, :textmagic_username
    remove_column :gateways, :textmagic_password
  end
end
