class Delivery < ActiveRecord::Base
  belongs_to :entry
  belongs_to :user
  belongs_to :channel
  
  # No delivery, if during quiet hours for this user or they are not active  
  # If the user doesn't need anymore we leave
  def self.deliver_to(subscription)
    user = subscription.user
    channel = subscription.channel
    return unless user && channel
    return unless user.active? && user.number_confirmed? && channel.active?
    return if user.quiet_hours?
    return if recent_delivery?(user)
    need = subscription.number_per_day - self.delivery_count(subscription)
    return unless need > 0
    since = self.last_delivered_entry_id(subscription)
    entry = Entry.last(:conditions => ["id > ? AND feed_id IN (?)", since, channel.feeds.map(&:id)])
    self.deliver(user.id, channel.id, entry, PRIORITY[:low]) if entry
  rescue Exception => e
    # Bad subscription
    Rails.logger.error "Could not deliver to subscription: #{e.message}"
  end
  
  def self.recent_delivery?(user)
    last_delivery_time = self.last_delivered_entry_time(user.id)
    return false unless last_delivery_time
    minutes_since_last_delivery = ((Time.zone.now - last_delivery_time) / 1.minute)
    minutes_since_last_delivery < user.delay
  end

  # Only deliver system messages that have no published date, or that are now
  # published and that have not been delivered already.
  def self.deliver_system_messages_to(user, channel)
    return unless user.gateway && user.gateway.region_id && user.gateway.region_id == channel.region_id
    return unless user.active? && user.number_confirmed? && channel.active?
    return if user.quiet_hours? && !channel.emergency?
    priority = channel.emergency? ? PRIORITY[:emergency] : PRIORITY[:normal]
    entries = Entry.available(user.id, channel.id, 0, :all).all(:conditions => ['(published_at IS NULL OR published_at < ?) AND (entries.created_at >= ?)', Time.zone.now, user.created_at])
    entries.each {|entry| self.deliver(user.id, channel.id, entry, priority) }        
  rescue Exception => e
    Rails.logger.error "Could not deliver system messages to user #{user.id}: #{e.message}"
  end
  
  # Find the oldest popular message needed for this user
  def self.deliver_popular_messages_to(user)
    return unless user.active? && user.number_confirmed? && user.gateway && user.gateway.region_id
    return if user.quiet_hours?
    # Should popular messages wait?
    popular = Popular.first(:include => :entry,
      :joins => "LEFT JOIN deliveries ON deliveries.entry_id = popular.entry_id AND deliveries.user_id = #{user.id} " +
               "INNER JOIN channels ON channels.id = popular.channel_id AND channels.region_id = #{user.gateway.region_id}", 
      :conditions => 'deliveries.entry_id IS NULL', 
      :limit => 1)
    return unless popular    
    self.deliver(user.id, popular.channel_id, popular.entry, PRIORITY[:normal])    
  rescue Exception => e
    Rails.logger.error "Could not deliver popular messages to user #{user.id}: #{e.message}"
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
      :order => 'entry_id DESC').entry_id rescue 0
  end    

  def self.delivery_count(subscription)
    since = subscription.user.start_of_day
    Delivery.count(:conditions => [
      'user_id = ? AND channel_id = ? AND created_at > ?', 
      subscription.user_id, 
      subscription.channel_id, 
      since])    
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
  rescue Exception => e
    Rails.logger.error "Could not deliver message to user #{user_id}: #{e.message}"
  end
    
end