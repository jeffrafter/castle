require File.expand_path(File.dirname(__FILE__) + "/../test_helper")

class EntryTest < ActiveSupport::TestCase
  setup do
    @entry = Factory(:entry)
  end
  
  should_validate_presence_of :feed
  should_belong_to :feed
  
  context "entries" do
    should "set the message content before saving"
    should "have a scope for unprocessed entries"
    should "have a scope for available entries"
  end
  
  context "available entries" do
    setup do
      # Clear the previous setup
      Entry.delete_all
      @user = Factory(:user_with_number)
      @channel = Factory(:channel)
      @feed = Factory(:feed, :channel_id => @channel.id)
      5.times { Factory(:entry, :feed_id => @feed.id) }       
    end
    
    should "limit the results based on limit" do
      assert_equal 5, Entry.count
      @entries = Entry.available(@user.id, @channel.id, 4)
      assert_equal 4, @entries.length
    end
    
    should "sort by in reverse chronological order"
    should "find the most recent entries"
    should "not include entries that have already been delivered to the user"
    should "not include entries from other channels"
    should "not include entries that are older than the last received entry for the user"
  end
end
