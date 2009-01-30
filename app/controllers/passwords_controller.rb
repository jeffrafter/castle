class PasswordsController < ApplicationController
  skip_before_filter :authenticate, [:new, :create]
  include Clearance::App::Controllers::PasswordsController
end
