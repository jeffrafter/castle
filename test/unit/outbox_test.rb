require File.dirname(__FILE__) + '/../test_helper'

class OutboxTest < ActiveSupport::TestCase
  setup do
    @message = Factory(:outbox)
  end
  
  should_validate_presence_of :number, :gateway, :text
  should_belong_to :gateway  
end
