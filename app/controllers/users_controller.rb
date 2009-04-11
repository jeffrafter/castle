class UsersController < ApplicationController
  skip_before_filter :authenticate, [:new, :create, :verify]
  resource_controller
  include Clearance::App::Controllers::UsersController

  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html
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
    conditions = ['user.number LIKE ?', '%' + params[:number] + '%'] unless params[:number].blank?
    @users = User.paginate(:page => params[:page], :per_page => 10)
  end
  
  def activate
    @user = User.find(params[:id])
    @user.activate
    redirect_to @user
  end
  
  def deactivate
    @user = User.find(params[:id])
    @user.deactivate
    redirect_to @user
  end
  
  def confirm
    @user = User.find(params[:id])
    @user.confirm
    redirect_to @user
  end
  
  def tell
    @user = User.find(params[:id])
    if @user.quiet_hours?
      flash[:notice] = "It is currently the user's quiet hours"
      redirect_to :back
      return
    end
    @user.tell(params[:text])
    redirect_to @user
  end
  
  def invite
  end
end