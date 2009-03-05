require 'time'

namespace :feeds do
  desc "Fetch the latest updates from all of the feeds"
  task :fetch do
    require File.join(RAILS_ROOT, 'config', 'environment')
    feeds = Feed.enabled.stale.all
    feeds.each {|feed| 
      puts "[#{Time.now.iso8601}] Checking for updates to #{feed.feed_url}"
      feed.fetch       
    }
  end
  
  desc "Deliver new messages to the users that need them"
  task :deliver do
    require File.join(RAILS_ROOT, 'config', 'environment')

# Way slow version right?
    subscriptions = Subscription.all
    subscriptions.each {|sub| Delivery.deliver_to(sub) }
    
=begin
    subscriptions = Subscription.needy  
    subscriptions.each {|subscription| subscription.delivery_count = subscription.delivery_count.to_i}
    entries = Entry.unprocessed.all
    entries.each  do |entry|       
      puts "[#{Time.now.iso8601}] Processing entry #{entry.checksum}"
      subscriptions.each do |subscription|
        next unless entry.feed
        next unless subscription.channel_id = entry.feed.channel_id
        next unless subscription.number_per_day > subscription.delivery_count
        subscription.delivery_count += 1
        Delivery.deliver(subscription, entry)
      end  
      entry.processed = true
      entry.save!      
    end    
=end    
  end
  
  desc "Fetch and deliver"
  task :sync => [:fetch, :deliver] do
  end
  
end  
