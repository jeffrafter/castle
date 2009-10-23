class TextmagicController < ApplicationController
  # When setting up the callback you need to include the api_id param!
  before_filter :find_gateway

  def callback
    raise "Invalid message" unless outbox = Outbox.find_by_identifier(params[:message_id])
    outbox.status = params[:status]
    outbox.charge = params[:charge]
    outbox.save!
    render :nothing => true
  rescue Exception => e
     Rails.logger.error "Error attempting to process message #{e.message} (#{e.backtrace.join("\n")}"
    render :text => e.message + "\n#{e.backtrace}", :status => :error
  end      
  
  def create
    raise "#{params}"
#    render(:nothing => true, :status => :ok) and return if params[:from].blank?

    # Not currently using params[:identifier]
    @message = Inbox.create(
      :gateway => @gateway,
      :sent_at => Time.zone.at(params[:timestamp].to_i), 
      :number => params[:from],
      :text => params[:text])                                  
    @processor = Message::Processor.new(@message)
    @processor.run
    render :nothing => true, :status => :ok      
  rescue Exception => e
    Rails.logger.error "Error attempting to process message #{e.message} (#{e.backtrace.join("\n")}"
    render :text => e.message + "\n#{e.backtrace}", :status => :error 
  end
end
