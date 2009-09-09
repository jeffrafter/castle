class CommandsController < ApplicationController
  before_filter :redirect_to_root, :unless => :signed_in?
  resource_controller
end
