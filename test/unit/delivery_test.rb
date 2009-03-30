require 'test_helper'

class DeliveryTest < ActiveSupport::TestCase
  setup do
    @delivery = Factory(:delivery)
  end

  should_belong_to :entry, :user, :channel
  
  context "deliveries" do
    setup do
    end
  
    should "deliver an entry"
    should "count the number of deliveries in the past day"
    should "deliver available entries to the subscription"
    should "not deliver to subscriptions for inactive users"
    should "not deliver during a user's quiet hours"
    should "not deliver more entries than the subscription limit in a given day"
  end
end
