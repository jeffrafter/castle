class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :channel
  validates_presence_of :user, :channel
  
  # We need a scope that allows us to quickly retrieve all subscriptions which
  # need more deliveries today (sorry I didn't wrap these lines)
  named_scope :needy, lambda {|channel_id| {
    :select => "subscriptions.id AS id, subscriptions.user_id AS user_id, subscriptions.channel_id AS channel_id, subscriptions.number_per_day AS number_per_day, IFNULL(deliveries.delivery_count, 0) AS delivery_count",
    :joins => "LEFT OUTER JOIN (SELECT *, COUNT(*) AS delivery_count FROM deliveries) AS deliveries ON deliveries.user_id = subscriptions.user_id AND deliveries.channel_id = subscriptions.channel_id AND deliveries.created_at > '#{Time.today.iso8601}'",
    :group => "subscriptions.user_id, subscriptions.channel_id HAVING IFNULL(deliveries.delivery_count, 0) < subscriptions.number_per_day"  
  }}

  def more
    self.number_per_day += 5
    self.save
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