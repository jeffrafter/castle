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

    should "generate key" do
      @gateway.send(:generate_key)
      assert_not_nil @gateway.api_key
      assert_nil @gateway.api_key_expires_at
    end
  end
end
