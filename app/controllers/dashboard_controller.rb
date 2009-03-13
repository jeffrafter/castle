class DashboardController < ApplicationController
  before_filter :authenticate
  
  def deliver
    subscriptions = Subscription.all
    subscriptions.each {|sub| Delivery.deliver_to(sub) }
    redirect_to :index    
  end
end
