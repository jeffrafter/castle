# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.time_zone = 'UTC'
  config.action_controller.session = {
    :session_key => '_admin_session',
    :secret      => 'e1532a15f8aa3f7cd70e9d423761432fb3cf94a9e787227942e3d8bdd38d3c3e74787e7d5194829f32d5e313337703d9069c9c719bb68a2c51de19f176025e8f'
  }
  config.gem "mislav-will_paginate", :lib => "will_paginate"
  config.gem "thoughtbot-clearance", :lib => "clearance"
end

DO_NOT_REPLY = "donotreply@datadyne.socialrange.org" 
PROJECT_NAME = "News for Cell Phones"

# For cron tasks
require 'whenever'