ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'shoulda'
require 'factory_girl'
require 'clearance/../../shoulda_macros/clearance'

Dir[File.join(RAILS_ROOT, 'test', 'factories', '**', '*')].each {|f| require f }

class Test::Unit::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  include Clearance::Test::TestHelper
  
  def should_send_message_to(number, matcher = nil, &block)
    count = Outbox.count
    yield
    assert_equal count + 1, Outbox.count
    message = Outbox.first(:order => 'id DESC')
    assert_equal number, message.number    
    assert_match matcher, message.text if matcher
  end  

  def should_not_send_message_to(number, &block)
    count = Outbox.count
    yield
    assert_equal count, Outbox.count
  end    
end