class EntriesController < ApplicationController
  before_filter :set_locale

  def set_locale
    I18n.locale = params[:locale] || 'en'
  end 
   
  resource_controller  

  def index
    if params[:feed_id]
      @entries = Entry.paginate_by_feed_id(params[:feed_id], :page => params[:page], :per_page => 10, :order => 'created_at DESC')
    else
      @entries = Entry.paginate(:page => params[:page], :per_page => 10, :order => 'created_at DESC')
    end      
  end
  
  def show
    redirect_to entries_path
  end  
end