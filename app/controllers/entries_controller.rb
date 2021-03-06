class EntriesController < ApplicationController
  before_filter :set_locale
  before_filter :redirect_to_root, :unless => :signed_in?

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
end