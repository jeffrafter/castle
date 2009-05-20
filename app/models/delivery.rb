class Delivery < ActiveRecord::Base
  belongs_to :entry
  belongs_to :user
  belongs_to :channel

  named_scope :last, :limit => 1, :order_by => 'id DESC'
  
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
    last_delivery_time = self.last_delivered_entry_time(subscription.user_id)
    return if last_delivery_time && (Time.now - last_delivery_time) < 1.hour
    since = self.last_delivered_entry_id(subscription)
    entries = Entry.available(user.id, channel.id, since, need).reverse!    
    entries.each {|entry| self.deliver(user.id, channel.id, entry, PRIORITY[:low]) }
  rescue Exception => e
    # Bad subscription
    puts "Could not deliver to subscription: #{e.message}"
  end

  # Only deliver system messages that have no published date, or that are now
  # published and that have not been delivered already.
  def self.deliver_system_messages_to(user, channel)
    return unless user.active? && channel.active?
    return if user.quiet_hours? && !channel.emergency?
    priority = channel.emergency? ? PRIORITY[:emergency] : PRIORITY[:normal]
    entries = Entry.available(user.id, channel.id, 0, :all).all(
      :conditions => ['(published_at IS NULL OR published_at < ?) AND (created_at > ? OR published_at > ?)', 
        Time.now, user.created_at, user.created_at]).reverse!    
    entries.each {|entry| self.deliver(user.id, channel.id, entry, priority) }        
  end
  
private
  def self.last_delivered_entry_time(user_id)
    Delivery.first(:conditions => ['user_id = ?', user_id],
      :order => 'created_at DESC').created_at rescue nil
  end    

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

  def self.deliver(user_id, channel_id, entry, priority = nil)
    priority ||= PRIORITY[:none]
    ActiveRecord::Base.transaction do
      delivery = Delivery.create(
        :channel_id => channel_id, 
        :user_id => user_id, 
        :entry_id => entry.id)
      delivery.user.tell(entry.message, priority)  
    end  
  end
    
end