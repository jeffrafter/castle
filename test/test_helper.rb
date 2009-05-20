ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'shoulda'
require 'factory_girl'
require 'clearance/../../shoulda_macros/clearance'

Dir[File.join(RAILS_ROOT, 'test', 'factories', '**', '*')].each {|f| require f }

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  
  def should_send_message_to(number, matcher = nil, &block)
    count = Outbox.count
    yield
    assert Outbox.count > count
    message = Outbox.first(:order => 'id DESC')
    assert_equal number, message.number    
    assert_match matcher, message.text if matcher
  end  

  def should_not_send_message_to(number, &block)
    count = Outbox.count
    yield
    assert_equal count, Outbox.count
  end    
  
  def should_raise(*args, &block)
    opts = args.first.is_a?(Hash) ? args.fist : {}
    opts[:kind_of] = args.first if args.first.is_a?(Class)
    yield block
    flunk opts[:message] || "should raise an exception, but none raised"
  rescue Exception => e
    assert e.kind_of?(opts[:kind_of]), opts[:message] || "should raise exception of type #{opts[:kind_of]}, but got #{e.class} instead" if opts[:kind_of]
  end
    
end