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
  Test::Unit::TestCase.fixtures :all

  def login_user(email, password) 
    post "/login", {:session => { :email => email, :password => password }}
    @user = @controller.current_user
  end

  def logout_user
    get "/logout"
    @user = nil
  end
  
end  

World do |world|
  world.extend(CucumberWorldExtension)
  world
end
