class DashboardController < ApplicationController
  before_filter :redirect_to_root, :unless => :signed_in?

  def index; end
  
  def deliver
    subscriptions = Subscription.all
    subscriptions.each {|sub| Delivery.deliver_to(sub) }
    redirect_to :index    
  end
end
