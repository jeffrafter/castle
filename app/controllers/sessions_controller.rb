class SessionsController < ApplicationController
  skip_before_filter :authenticate, [:new, :destroy, :create, :verify]
  include Clearance::App::Controllers::SessionsController
  rescue_from ActiveRecord::RecordNotFound do |e| render :text => e.message, :status => :not_found; end
  rescue_from Exception do |e| render :text => e.message, :status => :error; end
end
