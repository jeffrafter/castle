class AddRegionIdToRating < ActiveRecord::Migration
  def self.up
    add_column :ratings, :region_id, :integer
  end

  def self.down
    drop_column :ratings, :region_id
  end
end
