class Delivery < ActiveRecord::Base
  belongs_to :entry
  belongs_to :user
  belongs_to :channel
  
  # No delivery, if during quiet hours for this user or they are not active  
  # If the user doesn't need anymore we leave
  def self.deliver_to(subscription)
    user = User.find(subscription.user_id)    
    return unless user.active?
    return if user.quiet_hours?
    need = subscription.number_per_day - self.delivery_count(subscription)
    return unless need > 0
    entries = Entry.available(subscription.user_id, subscription.channel_id, need).reverse!    
    entries.each {|entry| self.deliver(subscription, entry) }
  end
  
private

  def self.delivery_count(subscription)
    Delivery.count(:conditions => [
      'user_id = ? AND channel_id = ? AND created_at > ?', 
      subscription.user_id, 
      subscription.channel_id, 
      Time.now - 24.hours])    
  end    

  def self.deliver(subscription, entry)
    ActiveRecord::Base.transaction do
      delivery = Delivery.create(
        :channel_id => subscription.channel_id, 
        :user_id => subscription.user_id, 
        :entry_id => entry.id)
      delivery.user.tell(entry.message)  
    end  
  end
    
end