ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'shoulda'
require 'factory_girl'
require 'clearance/../../shoulda_macros/clearance'

factories = Dir[File.join(RAILS_ROOT, 'test', 'factories', '**', '*.rb')].map { |h| h[0..-4] }
factories.each {|f| require f }

class Test::Unit::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  include Clearance::Test::TestHelper
end