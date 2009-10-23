require File.dirname(__FILE__) + '/../test_helper'

class OutboxTest < ActiveSupport::TestCase
  setup do
    @message = Factory(:outbox)
  end
  
  should_validate_presence_of :number, :gateway, :text
  should_belong_to :gateway  
  
  context "for textmagic gateways" do
    setup do
      @gateway = Factory(:gateway, :textmagic_username => 'tmuser', :textmagic_password => 'tmpass')
    end
    
    should "deliver the message to textmagic if the textmagic username and password are present" do
      TextMagic::API.any_instance.stubs(:send).returns('12345')
      @message = Factory(:outbox, :gateway => @gateway)
      @message.reload
      assert_equal 12345, @message.identifier
    end
  end  
end
