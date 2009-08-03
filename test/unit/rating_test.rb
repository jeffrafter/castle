require 'test_helper'

class RatingTest < ActiveSupport::TestCase
  setup do
    @rating = Factory(:rating)
  end

  should_belong_to :region, :user, :entry
  should_validate_uniqueness_of :entry_id, :scoped_to => :user_id

  context "deliveries for entries on system channels" do
    setup do
      @channel = Factory(:channel, :system => true)
      @feed = Factory(:feed, :channel => @channel)
      @entry = Factory(:entry, :feed => @feed)          
    end

    should "allow ratings" do
      @rating = Factory.build(:rating, :entry => @entry)
      assert @rating.valid?
    end
  end  
end
