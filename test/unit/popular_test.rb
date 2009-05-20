require File.expand_path(File.dirname(__FILE__) + "/../test_helper")

class PopularTest < ActiveSupport::TestCase  
  context "when fetching the most popular items from yesterday" do  
    setup do
      # A popular feed for the items to be pushed to
      @region = Factory(:region)
      @channel = Factory(:channel, :region => @region, :popular => true)
      @feed = Factory(:feed, :channel => @channel)
      
      # Two ratings for a single entry
      @entry = Factory(:entry)      
      Factory(:rating, :entry_id => @entry.id, :region_id => @region.id)
      Factory(:rating, :entry_id => @entry.id, :region_id => @region.id)

      # Three random ratings
      Factory(:rating, :region_id => @region.id)
      Factory(:rating, :region_id => @region.id)
      Factory(:rating, :region_id => @region.id)
    end

    should "rank the items by the number of ratings" do
      count = Entry.count
      Popular.populate(@region.id)
      assert_equal count+3, Entry.count
    end
  end
  
end