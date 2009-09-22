require File.expand_path(File.dirname(__FILE__) + "/../test_helper")

class PopularTest < ActiveSupport::TestCase  
  context "when fetching the most popular items from yesterday" do  
    setup do
      @region = Factory(:region)
      @channel = Factory(:channel, :region => @region)
      @feed = Factory(:feed, :channel => @channel)
      
      # Four ratings for a single entry
      @entry = Factory(:entry)      
      Factory(:rating, :entry_id => @entry.id, :region_id => @region.id)
      Factory(:rating, :entry_id => @entry.id, :region_id => @region.id)
      Factory(:rating, :entry_id => @entry.id, :region_id => @region.id)
      Factory(:rating, :entry_id => @entry.id, :region_id => @region.id)
    end

    should "not consider items popular until they have five votes" do
      Popular.total(@entry.id, @entry.feed.channel_id)
      assert_equal 0, Popular.count      
    end
    
    should "consider an item popular if it gets five votes" do
      Factory(:rating, :entry_id => @entry.id, :region_id => @region.id)
      Popular.total(@entry.id, @entry.feed.channel_id)
      assert_equal 1, Popular.count
    end
    
    should "not duplicate popular entries" do
      Factory(:rating, :entry_id => @entry.id, :region_id => @region.id)
      Popular.total(@entry.id, @entry.feed.channel_id)
      Factory(:rating, :entry_id => @entry.id, :region_id => @region.id)
      Popular.total(@entry.id, @entry.feed.channel_id)
      assert_equal 1, Popular.count
    end
    
  end
  
end