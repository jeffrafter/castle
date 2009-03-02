require 'test_helper'

class EntryTest < ActiveSupport::TestCase
  setup do
    @entry = Factory(:entry)
  end
  
  should_validate_presence_of :feed
  should_validate_uniqueness_of :url
  should_belong_to :feed
end
