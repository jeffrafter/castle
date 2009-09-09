require File.dirname(__FILE__) + '/../test_helper'

class SubscriptionTest < ActiveSupport::TestCase
  context "User subscribed to channel" do
    setup do
      @user = Factory(:registered_user)
      @channel = Factory(:channel)
      @feed = Factory(:feed, :channel => @channel)
      @subscription = Factory(:subscription, :user => @user, :channel => @channel)
    end

    should_belong_to :user  
    should_belong_to :channel
    should_validate_presence_of :user, :channel

    context "with no deliveries today" do
    end

    context "with maximum deliveries yesterday and no deliveries today" do
    end
    
    context "with one remaining delivery today" do
    end

    context "with maximum deliveries already today" do
    end
    
  end  
end
