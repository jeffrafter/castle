class SessionsController < ApplicationController
  skip_before_filter :authenticate, [:new, :destroy, :create, :verify]
  include Clearance::App::Controllers::SessionsController
  rescue_from ActiveRecord::RecordNotFound do |e| render :text => e.message, :status => :not_found; end
  rescue_from Exception do |e| render :text => e.message, :status => :error; end

  # Handle unconfirmed but registered numbers (from invites)  
  # Handle deactivations
  def verify
    @user = User.find_by_number!(params[:number])
    sign_user_in(@user)                  
    unless (@user.number_confirmed?)
      @message = Message.create(:number => @user.number, :message => 'Thanks for joining. To get help, reply to this message with "help"')
      @user.number_confirmed = true
      @user.save!
      render :text => 'halt', :status => :error
      return
    end
    respond_to do |format|
      format.xml  { render :xml => @user }
    end  
  end
end
