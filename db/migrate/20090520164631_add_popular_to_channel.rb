class AddPopularToChannel < ActiveRecord::Migration
  def self.up
    add_column :channels, :popular, :boolean, :default => false
  end

  def self.down
    drop_column :channels, :popular
  end
end
