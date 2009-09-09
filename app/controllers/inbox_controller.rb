class InboxController < ApplicationController
  before_filter :redirect_to_root, :unless => :signed_in?
  before_filter :find_gateway, :only => [:create]
  skip_before_filter :redirect_to_root, :only => [:create]
  
  def create
    @message = Inbox.create(params[:inbox].merge(:gateway => @gateway))
    @processor = Message::Processor.new(@message)
    @processor.run
    render :nothing => true, :status => :ok      
  rescue Exception => e
    render :text => e.message + "\n#{e.backtrace}", :status => :error 
  end    
  
  def index
    if params[:number]
      @messages = Inbox.paginate_by_number(params[:number], :page => params[:page], :per_page => 10, :order => 'created_at DESC')
    else
      @messages = Inbox.paginate(:page => params[:page], :per_page => 10, :order => 'created_at DESC')
    end          
  end
end
