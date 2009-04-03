class Delivery < ActiveRecord::Base
  belongs_to :entry
  belongs_to :user
  belongs_to :channel
  
  # No delivery, if during quiet hours for this user or they are not active  
  # If the user doesn't need anymore we leave
  def self.deliver_to(subscription)
    user = User.find(subscription.user_id)
    channel = Channel.find(subscription.channel_id)
    return unless user && channel
    return unless user.active? && channel.active?
    return if user.quiet_hours?
    need = subscription.number_per_day - self.delivery_count(subscription)
    return unless need > 0
    since = self.last_delivered_entry_id(subscription)
    entries = Entry.available(user.id, channel.id, since, need).reverse!    
    entries.each {|entry| self.deliver(user.id, channel.id, entry) }
  end

  def self.deliver_system_messages_to(user, channel)
    return unless user.active? && channel.active?
    return if user.quiet_hours?
    since = self.last_delivered_entry_id(subscription)
    entries = Entry.available(user.id, channel.id, since, need).reverse!    
    entries.each {|entry| self.deliver(user.id, channel.id, entry) }        
  end
  
private
  def self.last_delivered_entry_id(subscription)
    Delivery.first(:conditions => [
      'user_id = ? AND channel_id = ?', 
      subscription.user_id, 
      subscription.channel_id],
      :order => 'entry_id DESC').id rescue 0
  end    

  def self.delivery_count(subscription)
    Delivery.count(:conditions => [
      'user_id = ? AND channel_id = ? AND created_at > ?', 
      subscription.user_id, 
      subscription.channel_id, 
      Time.now - 24.hours])    
  end    

  def self.deliver(user_id, channel_id, entry)
    ActiveRecord::Base.transaction do
      delivery = Delivery.create(
        :channel_id => channel_id, 
        :user_id => user_id, 
        :entry_id => entry.id)
      delivery.user.tell(entry.message)  
    end  
  end
    
end