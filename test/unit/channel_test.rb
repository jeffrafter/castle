require 'test_helper'

class ChannelTest < ActiveSupport::TestCase
  setup do
    @channel = Factory(:channel)
  end

  should_have_named_scope :enabled, :conditions => ['active = ?', true]
  should_validate_presence_of :keywords
  should_belong_to :region
  should_have_many :feeds
end
