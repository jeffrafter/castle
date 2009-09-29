require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ChannelTest < ActiveSupport::TestCase
  setup do
    @channel = Factory(:channel)
  end

  should_have_named_scope :enabled, :conditions => ['active = ?', true]
  should_validate_presence_of :keywords
  should_belong_to :region
  should_have_many :feeds
  
  context "available" do
    setup do
      @user = Factory(:user_with_number)
      @available_channels = [
        Factory(:channel, :region => @user.gateway.region),
        Factory(:channel, :region => @user.gateway.region),
        Factory(:channel, :region => @user.gateway.region)]
    end  

    should "show channels from this region" do
      assert_equal @available_channels, @user.gateway.region.channels.available(@user.id).all
    end

    should "not show channels from other regions" do
      assert !@user.gateway.region.channels.available(@user.id).all.include?(@channel)
    end

    should "show channels that the user is not subscribed to" do
      @subscription = Factory(:subscription, :channel => @available_channels[0], :user => @user)
      assert_equal @available_channels[1..2], @user.gateway.region.channels.available(@user.id).all
    end
    
    should "not show channels that the user is subscribed to" do
      @subscription = Factory(:subscription, :channel => @available_channels[0], :user => @user)
      assert !@user.gateway.region.channels.available(@user.id).all.include?(@available_channels[0])
    end
    
    should "show channels even if another user is subscribed to them" do
      @another_user = Factory(:user_with_number, :gateway => @user.gateway)
      @subscription = Factory(:subscription, :channel => @available_channels[0], :user => @another_user)
      assert_equal @available_channels, @user.gateway.region.channels.available(@user.id).all      
    end
    
  end
end
