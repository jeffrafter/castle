class FeedsController < ApplicationController
  before_filter :redirect_to_root, :unless => :signed_in?
  resource_controller  
  def show
    @feed = Feed.find(params[:id])
    @entries = Entry.paginate_by_feed_id(@feed.id, :page => params[:page], :per_page => 10, :order => 'created_at DESC')
  end
end