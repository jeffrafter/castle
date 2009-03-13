class SmsController < ApplicationController
  has_sms_fu

  def index
  end

  def create
    deliver_sms(params[:sms][:number],
                params[:sms][:carrier],
                params[:sms][:text],
                :from => params[:sms][:from])
    flash[:notice] = "Message sent"
    redirect_to :index
  end
end
