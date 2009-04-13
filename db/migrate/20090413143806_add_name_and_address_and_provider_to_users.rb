class AddNameAndAddressAndProviderToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :name, :string
    add_column :users, :address, :string
    add_column :users, :provider, :string
    add_column :users, :prepaid, :boolean, :default => false
    add_column :users, :details, :string
  end

  def self.down
    remove_column :users, :name
    remove_column :users, :address
    remove_column :users, :provider
    remove_column :users, :prepaid
    remove_column :users, :details
  end
end
