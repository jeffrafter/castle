ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'shoulda'
require 'factory_girl'
require 'test/factories/clearance'
require 'clearance/../../shoulda_macros/clearance'

class Test::Unit::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  include Clearance::Test::TestHelper
end