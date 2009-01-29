require 'test_helper'

class EntryTest < ActiveSupport::TestCase
  setup do
    @entry = Factory(:entry)
  end
  
  should_require_attributes :channel
  should_require_unique_attributes :link
  should_belong_to :channel
end
