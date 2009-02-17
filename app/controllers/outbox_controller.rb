class OutboxController < ApplicationController
  resource_controller
  responds_to :xml
  before_filter :find_gateway
  
  def index
    since = Time.parse(params[:since]) rescue Time.now
    options = {}
    options[:conditions] = ['updated_at > ?', since] if since
    @messages = Outbox.all(options)
    respond_to do |format|
      format.html
      format.xml  { render :xml => @messages.to_xml }
    end
  end
end
