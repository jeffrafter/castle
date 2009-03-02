class OutboxController < ApplicationController
  before_filter :find_gateway
  
  def index
    since = Time.parse(params[:since]) rescue nil
    options = {}
    options[:conditions] = ['updated_at > ?', since] if since
    @messages = Outbox.all(options)
    render :xml => @messages.to_xml
  end
end
