class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :channel
  validates_presence_of :user, :channel
  
  # We need a scope that allows us to quickly retrieve all subscriptions which
  # need more deliveries today (sorry I didn't wrap these lines)
#  named_scope :needy, lambda {|channel_id| {
#    :select => "subscriptions.*, IFNULL(deliveries.delivery_count, 0) AS delivery_count",
#    :joins => "LEFT OUTER JOIN (SELECT COUNT(*) AS delivery_count, channel_id, user_id, created_at FROM deliveries GROUP BY channel_id, user_id HAVING created_at > '#{Time.today.iso8601}') AS deliveries ON deliveries.user_id = subscriptions.user_id AND deliveries.channel_id = subscriptions.channel_id",
#    :conditions => "IFNULL(deliveries.delivery_count, 0) < subscriptions.number_per_day"  
#  }}

  named_scope :system, {}
  named_scope :user, {}

  def more
    self.number_per_day += 5
    self.save
    Delivery.deliver_to(self)
  end
  
  def less
    self.number_per_day -= 5
    self.number_per_dat = 0 if self.number_per_day < 0
    self.save
  end
  
  def none
    self.number_per_dat = 0
    self.save
  end
end