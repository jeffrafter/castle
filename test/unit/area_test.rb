require 'test_helper'

class AreaTest < ActiveSupport::TestCase
  setup do
    @area = Factory(:area)
  end
  
  should_require_attributes :name, :country_code, :area_code, :region
  should_belong_to :region
end
