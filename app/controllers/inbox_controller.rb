class InboxController < ApplicationController
  before_filter :find_gateway
  rescue_from Exception do |e| render :text => e.message, :status => :error; end
  
  def create
    @message = Inbox.create(params[:inbox].merge(:gateway => @gateway))
    @processor = Message::Processor.new(@message)
    @processor.run
    render :nothing => true, :status => :ok      
  end    
end
