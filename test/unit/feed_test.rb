require 'test_helper'

class FeedTest < ActiveSupport::TestCase
  should_belong_to :channel
  should_have_many :entries
  
  context "feed fetching" do
    setup do
      @feed = Factory(:feed)
    end
    #should "skip feeds that have not been modified"
    #should "skip feeds that return errors"
    #should "handle feeds that have been modified and do not have errors"
    #should "skip feeds with matching checksums"
    #should "skip feeds with no items"
    #should "skip feeds with no title"
    #should "cache all of the entries in reverse until a match is found for the last checksum"
    #should "update the modified date based on the last modified header or response time"
    #should "update the tag"
    should "strip html tags" do
      @feed.fetch
      # just check the first entry, "la tercera" feeds always contain html tags
      assert !(@feed.entries[0].summary =~ /[<>]/)
    end
  end
end
