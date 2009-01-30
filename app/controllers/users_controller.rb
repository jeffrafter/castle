class UsersController < ApplicationController
  skip_before_filter :authenticate, [:new, :create]
  include Clearance::App::Controllers::UsersController
end