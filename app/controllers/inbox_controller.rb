class InboxController < ApplicationController
  before_filter :find_gateway, :only => [:create]
  skip_before_filter :authenticate, :only => [:create]
#  rescue_from Exception do |e| render :text => e.message + "\n" + e.backtrace, :status => :error; end
  
  def create
    @message = Inbox.create(params[:inbox].merge(:gateway => @gateway))
    @processor = Message::Processor.new(@message)
    @processor.run
    render :nothing => true, :status => :ok      
  rescue Exception => e
    render :text => e.message + "\n" + e.backtrace, :status => :ok 
  end    
  
  def index
    if params[:number]
      @messages = Inbox.paginate_by_number(params[:number], :page => params[:page], :per_page => 10, :order => 'created_at DESC')
    else
      @messages = Inbox.paginate(:page => params[:page], :per_page => 10, :order => 'created_at DESC')
    end          
  end
end
