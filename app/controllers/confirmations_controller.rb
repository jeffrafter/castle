class ConfirmationsController < ApplicationController
  skip_before_filter :authenticate, :new
  include Clearance::App::Controllers::ConfirmationsController
end
