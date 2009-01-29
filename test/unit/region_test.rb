require 'test_helper'

class RegionTest < ActiveSupport::TestCase
  setup do
    @region = Factory(:region)
  end
  
  should_require_attributes :name, :country, :language
  should_require_unique_attributes :name, :scoped_to => :language
  should_have_many :areas
  should_have_many :channels
  should_have_many :gateways
end
