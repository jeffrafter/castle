require 'forgery_protection_extension'

class InvalidApiKeyError < RuntimeError; end

class ApplicationController < ActionController::Base
  helper :all
  include Clearance::App::Controllers::ApplicationController  
  rescue_from ActiveRecord::RecordNotFound do |e| render :text => e.message, :status => :not_found; end
  rescue_from Exception do |e| render :text => e.message, :status => :error; end
  
  def find_gateway
    @gateway = Gateway.find_by_api_key(params[:api_key])
    raise InvalidApiKeyError.new 'Invalid API key' unless @gateway
  end
  
  
#  protect_from_forgery
#  before_filter :authenticate
end
