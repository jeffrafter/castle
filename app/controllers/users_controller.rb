class UsersController < ApplicationController
  skip_before_filter :authenticate, [:new, :create, :verify]
  include Clearance::App::Controllers::UsersController

  def show
    @user = User.find(params[:id])
    respond_to do |format|
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
    @users = User.paginate(:page => params[:page], :per_page => 10)
  end
end