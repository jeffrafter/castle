# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] ||= "cucumber"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'cucumber/rails/world'

# Comment out the next line if you don't want Cucumber Unicode support
require 'cucumber/formatter/unicode'

# Comment out the next line if you don't want transactions to
# open/roll back around each scenario
Cucumber::Rails.use_transactional_fixtures

# Comment out the next line if you want Rails' own error handling
# (e.g. rescue_action_in_public / rescue_responses / rescue_from)
Cucumber::Rails.bypass_rescue

class ActiveSupport::TestCase
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


require 'webrat'

Webrat.configure do |config|
  config.mode = :rails
end

require 'cucumber/rails/rspec'
require 'webrat/core/matchers'