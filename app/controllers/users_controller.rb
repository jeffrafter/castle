class UsersController < ApplicationController
  skip_before_filter :authenticate, [:new, :create, :verify]
  resource_controller
  include Clearance::App::Controllers::UsersController

  def edit
    @user = User.find(params[:id])
    @from_user = Inbox.count(:conditions => ['number = ?', @user.number])
    @to_user = Outbox.count(:conditions => ['number = ?', @user.number])
    @ratings = 0
    respond_to do |format|
      format.html
      format.xml { render :xml => @user }
    end
  rescue ActiveRecord::RecordNotFound => rnf
    render :text => rnf.message, :status => :not_found
  rescue Exception => e
    render :text => e.message, :status => 500
  end

  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html { redirect_to users_path }
      format.xml { render :xml => @user }
    end
  rescue ActiveRecord::RecordNotFound => rnf
    render :text => rnf.message, :status => :not_found
  rescue Exception => e
    render :text => e.message, :status => 500
  end

  def verify
    @user = User.find_by_number(params[:number])
    respond_to do |format|
      format.xml { render :xml => @user }
    end
  rescue 
    render :text => '', :status => :not_found
  end
  
  def index
    conditions = ''
    conditions = ['number LIKE ?', '%' + params[:number] + '%'] unless params[:number].blank?
    @users = User.paginate(:page => params[:page], :per_page => 100, :conditions => conditions)
  end
  
  def activate
    @user = User.find(params[:id])
    @user.activate
    redirect_to :back
  end
  
  def deactivate
    @user = User.find(params[:id])
    @user.deactivate
    redirect_to :back
  end
  
  def confirm
    @user = User.find(params[:id])
    @user.confirm
    redirect_to :back
  end
  
  def tell
    @user = User.find(params[:id])
    if @user.quiet_hours?
      flash[:notice] = "It is currently the user's quiet hours"
      redirect_to :back
      return
    end
    @user.tell(params[:text])
    redirect_to :back
  end
  
  def register
    # We are not sending any messages
    @gateway = Gateway.find(params[:gateway])
    user = User.new(
      :number => params[:register],
      :gateway_id => @gateway.id, 
      :locale => @gateway.locale, 
      :timezone_offset => @gateway.timezone_offset) 
    user.number_confirmed = true
    user.save!
    redirect_to users_path
  end
  
  def invite
    @gateway = Gateway.find(params[:gateway])
    InviteHandler.new(self).invite(params[:invite], @gateway.id, @gateway.locale, @gateway.timezone_offset)
    redirect_to users_path
  end

end