ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'shoulda'
require 'webrat'
require 'factory_girl'
require 'test/factories/clearance'
require 'clearance/../../shoulda_macros/clearance'
require 'cucumber/rails/world'
Cucumber::Rails.use_transactional_fixtures

Webrat.configure do |config|
  config.mode = :rails
end

module CucumberWorldExtension
  # This may be overkill, but it cleans everything up nicely. If you wanted to
  # You could just use specific fixtures in tests. You could even stub the
  # fixtures method in your world
  #
  # def fixtures(*args)
  # Test::Unit::TestCase.fixtures args
  # end
  #
  Test::Unit::TestCase.fixtures :all
 
  def login_user(email, password)
    post "/login", {:session => { :email => email, :password => password }}
    @user = @controller.current_user
  end
 
  def logout_user
    get "/logout"
    @user = nil
  end
 
  # This is pretty dangerous because you really have to make sure you have a 
  # user to use this properly maintaining an instance variable across steps can 
  # sometimes lead to very brittle steps
  def me
    @user
  end
    
end  

World do |world|
  world.extend(CucumberWorldExtension)
  world
end
