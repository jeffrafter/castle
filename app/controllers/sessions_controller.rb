class SessionsController < ApplicationController
  skip_before_filter :authenticate, [:new, :destroy, :create]
  include Clearance::App::Controllers::SessionsController
end
