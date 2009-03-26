require 'test_helper'

class CommandTest < ActiveSupport::TestCase
  setup do
    @command = Factory(:command)
  end

  should_validate_presence_of :word, :key, :locale
end
