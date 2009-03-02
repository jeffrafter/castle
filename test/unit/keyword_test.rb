require 'test_helper'

class KeywordTest < ActiveSupport::TestCase
  setup do
    @keyword = Factory(:keyword)
  end
  
  should_belong_to :channel
  should_validate_presence_of :word, :language, :channel  
end
