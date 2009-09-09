require 'forgery_protection_extension'

class InvalidApiKeyError < RuntimeError; end

class ApplicationController < ActionController::Base
  include Clearance::Authentication
  protect_from_forgery
  before_filter :authenticate
  helper :all

  rescue_from ActiveRecord::RecordNotFound do |e| render :text => e.message, :status => :not_found; end
  rescue_from Exception do |e| 
    raise e if e.is_a?(ActionController::Forbidden)
    render :text => e.message, :status => :error
  end
  
  def find_gateway
    @gateway = Gateway.find_by_api_key(params[:api_key])
    raise InvalidApiKeyError.new('Invalid API key') unless @gateway
  end    
end
