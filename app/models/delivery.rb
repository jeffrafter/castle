class Delivery < ActiveRecord::Base
  belongs_to :entry
  belongs_to :user
  belongs_to :channel
  
  def self.deliver(subscription, entry)
    ActiveRecord::Base.transaction do
      delivery = Delivery.create(
        :channel_id => subscription.channel_id, 
        :user_id => subscription.user_id, 
        :entry_id => entry.id)
      delivery.user.tell(entry.message)  
    end  
  end
  
  def self.deliver_to(subscription)
    need = subscription.number_per_day - Delivery.count(:conditions => [
      'user_id = ? AND channel_id = ? AND created_at > ?', 
      subscription.user_id, 
      subscription.channel_id, 
      Date.today])
    
    # If the user doesn't need anymore we leave
    return unless need > 0

    # Now that we know how many they need, try to find that many for this 
    # channel that have not already been delivered to this user and are 
    # from today and make them the most recent
    entries = Entry.all(
      :limit => need, 
      :include => :feed, 
      :joins => "LEFT OUTER JOIN deliveries ON deliveries.entry_id = entries.id AND deliveries.user_id = #{subscription.user_id}", 
      :conditions => ['feeds.channel_id = ? AND deliveries.id IS NULL', subscription.channel_id],
      :order => 'entries.created_at DESC')

    # Even though we grabbed the most recent we still want to send them in order  
    entries.reverse!    
    entries.each {|entry| Delivery.deliver(subscription, entry) }
  end
end