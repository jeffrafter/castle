require 'time'

namespace :feeds do
  desc "Fetch the latest updates from all of the feeds"
  task :fetch do
    require File.join(RAILS_ROOT, 'config', 'environment')
    feeds = Feed.enabled.stale.all
    feeds.each {|feed| 
      puts "[#{Time.zone.now.iso8601}] Checking for updates to #{feed.feed_url}"
      feed.fetch       
    }
  end

  desc "Populate the popular messages from last night"
  task :popular do
    require File.join(RAILS_ROOT, 'config', 'environment')
    Region.all.each {|region| Popular.populate(region.id) }
  end  
  
  desc "Deliver new messages to the users that need them"
  task :deliver do
    require File.join(RAILS_ROOT, 'config', 'environment')

    # System messages
    t = Time.zone.now
    channels = Channel.system
    users = User.active
    users.each {|u|
      channels.each {|c|
        Delivery.deliver_system_messages_to(u, c) 
      }
    }
    puts "Delivered to all system messages #{Time.zone.now - t} elapsed"

    # Way slow version right?
    t = Time.zone.now
    subscriptions = Subscription.all(:include => [:user, :channel])
    subscriptions.each {|sub| Delivery.deliver_to(sub) }
    puts "Delivered to all subscriptions #{Time.zone.now - t} elapsed"    
  end
  
  desc "Fetch and deliver"
  task :sync => [:fetch, :deliver] do
  end
  
end  
