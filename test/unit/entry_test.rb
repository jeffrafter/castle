require File.expand_path(File.dirname(__FILE__) + "/../test_helper")

class EntryTest < ActiveSupport::TestCase
  setup do
    @entry = Factory(:entry)
  end
  
  should_validate_presence_of :feed
  should_belong_to :feed
  
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
      @entries = Entry.available(@user.id, @channel.id, 0, 4)
      assert_equal 4, @entries.length
    end          
  end
  
  context "messages" do
    setup do
      # Clear the previous setup
      Entry.delete_all
      @user = Factory(:user_with_number)
      @channel = Factory(:channel, :title => 'SchoolHouseRock')
      @feed = Factory(:feed, :channel_id => @channel.id)
    end
    
    should "include the channel title in the message" do
      entry = @feed.entries.create(:title => "Something strange", :content => "Hoogey, hoody hooda")
      assert_equal "[SchoolHouseRock] \"Something strange\" Hoogey, hoody hooda", entry.message.to_s
    end    
  end
end
