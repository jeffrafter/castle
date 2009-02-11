class MessagesController < ApplicationController
  resource_controller
  responds_to :xml
  
  def index
    since = Time.parse(params[:since])
    options = {}
    options[:conditions] = ['created_at > ? OR updated_at > ?', since, since] if since
    @messages = Message.find(:all, options)
    respond_to do |format|
      format.html
      format.xml  { render :xml => @messages.to_xml }
    end
  end
end
