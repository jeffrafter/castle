require 'test_helper'

class RegionTest < ActiveSupport::TestCase
  setup do
    @region = Factory(:region)
  end
  
  should_have_named_scope :enabled, :conditions => ['active = ?', true]
  should_validate_presence_of :name, :country
  should_validate_uniqueness_of :name
  should_have_many :areas
  should_have_many :channels
  should_have_many :gateways
  
  should "test channels text"
end
