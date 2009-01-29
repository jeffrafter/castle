require 'test_helper'

class GatewayTest < ActiveSupport::TestCase
  setup do
    @gateway = Factory(:gateway)
  end
  
  should_have_named_scope :enabled, :conditions => 'active = 1'
  should_require_attributes :number, :region
  should_belong_to :region
end
