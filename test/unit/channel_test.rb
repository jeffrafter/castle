require 'test_helper'

class ChannelTest < ActiveSupport::TestCase
  setup do
    @channel = Factory(:channel)
  end

  should_require_attributes :link
  should_belong_to :region
end
