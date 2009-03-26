require 'test_helper'

class GatewayTest < ActiveSupport::TestCase
  setup do
    @gateway = Factory(:gateway)
  end
  
  should_have_named_scope :enabled, :conditions => ['active = ?', true]
  should_validate_presence_of :number, :region, :locale, :timezone_offset
  should_belong_to :region

  context "default gateway" do
  
    setup do
      @gateway = Factory(:gateway)
    end

    should "format and clean valid phone numbers" do
      number = "5558675309"
      assert_equal number, @gateway.format_number(number)
    end
    
    should "raise an invalid number format error if the number is not valid" do
      should_raise InvalidPhoneNumberError do
        @gateway.format_number("911")
      end
    end
    
    should "remove non numeric digits" do
      number = "(555)-867-5309"
      assert_equal "5558675309", @gateway.format_number(number)
    end

    should "remove the country code" do
      number = "15558675309"
      assert_equal "5558675309", @gateway.format_number(number)
    end
    
    should "generate key" do
      @gateway.send(:generate_key)
      assert_not_nil @gateway.api_key
      assert_nil @gateway.api_key_expires_at
    end
  end
end
