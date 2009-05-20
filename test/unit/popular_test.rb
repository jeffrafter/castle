require File.expand_path(File.dirname(__FILE__) + "/../test_helper")

class PopularTest < ActiveSupport::TestCase  
  context "when fetching the most popular items from yesterday" do  
    setup do
      @region = Factory(:region)
      @channel = Factory(:channel, :region => @region, :popular => true)
      @feed = Factory(:feed, :channel => @channel)
      @entry = Factory(:entry)
      @rating = Factory(:rating, :region_id => @region.id)
      @another_rating = Factory(:rating, :region_id => @region.id)
      @yet_another_rating = Factory(:rating, :region_id => @region.id)
      Factory(:rating, :entry_id => @entry.id, :region_id => @region.id)
      Factory(:rating, :entry_id => @entry.id, :region_id => @region.id)
    end

    should "rank the items by the number of ratings" do
      count = Entry.count
      Popular.populate(@region.id)
      assert_equal Entry.count, count + 3
    end
  end
  
end