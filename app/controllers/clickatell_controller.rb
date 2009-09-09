CLICKATELL_USER = "clickatell"
CLICKATELL_PASSWORD = "clickatell"

class ClickatellController < ApplicationController
  def create
    raise "Invalid user or password" unless params[:username] == CLICKATELL_USER 
    raise "Invalid user or password" unless params[:password] == CLICKATELL_PASSWORD 
    message = Outbox.find(params[:cliMsgId])
    raise "Invalid message" unless message
    message.status = params[:status]
    message.charge = params[:charge]
    message.save!
    render :nothing => true, :status => :ok      
  rescue Exception => e
    render :text => e.message + "\n#{e.backtrace}", :status => :error 
  end      
end
