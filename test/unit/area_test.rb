require 'test_helper'

class AreaTest < ActiveSupport::TestCase
  setup do
    @area = Factory(:area)
  end
  
  should_validate_presence_of :name, :country_code, :area_code, :region
  should_belong_to :region
end
