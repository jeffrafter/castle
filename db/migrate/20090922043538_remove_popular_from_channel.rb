class RemovePopularFromChannel < ActiveRecord::Migration
  def self.up
    remove_column :channels, :popular
  end

  def self.down
    add_column :channels, :popular, :boolean, :default => false
  end
end
