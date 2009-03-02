require 'test_helper'

class ConversationTest < ActiveSupport::TestCase
  setup do
    @conversation = Factory(:conversation)
  end

  should_validate_presence_of :state, :user, :handler_id
  should_have_many :messages
  should_belong_to :user
  should_have_named_scope :current  
end
