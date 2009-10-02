require 'feedzirra'

# sanitize logic moved to String class
class String
  def sanitize_with_strip
    s = self.sanitize_without_strip
    s = Dryopteris.strip_tags(s)
    s.gsub!(/\xA0/," ") # &nbsp;
    s.gsub!(/[\r\n]/," ")
    s.gsub!(/\s\s+/," ")
    s.gsub!(/ : /,": ")
    s.gsub!(/ - /,"-")
    s.gsub!(/ \/ /,"/")
    s.gsub!(/\s([\.\?\!])/, '\1')
    s.gsub!(/\s+$/, "")
    s.gsub!(/^\s+/, "")
    s
  end
  alias_method_chain :sanitize, :strip
end

module Feedzirra
  module FeedEntryUtilities
    # moved this method from jeff's gem to here, in order to use the official gem        
    def checksum
      Digest::MD5.hexdigest("#{title}--#{url}--#{summary}--#{content}")
    end
  end
end

class Feed < ActiveRecord::Base
  belongs_to :channel
  has_many :entries
  named_scope :enabled, :conditions => ['active = ?', true]
  named_scope :stale, lambda {{ :conditions => ['stale_at < ? OR stale_at IS NULL', Time.zone.now] }}
  before_create :setup
    
  # TODO! Google feeds seem to mess these up, maybe the latest feedzirra fixes
  #   options[:if_modified_since] = self.last_modified if self.last_modified
  #   options[:if_none_match] = self.etag if self.etag
  def fetch
    options = {:on_success => method(:success), :on_failure => method(:failure), :timeout => 30}
    feed = Feedzirra::Feed.fetch_and_parse(self.feed_url, options)
  rescue Exception => e
    puts "Failure fetching feed: #{e.message}"    
  end

private

  def setup   
    return if feed_url.blank?    
    feed = Feedzirra::Feed.fetch_and_parse(self.feed_url)
    self.title ||= feed.title
    self.url ||= feed.url
    self.etag = feed.etag
    self.last_modified = feed.last_modified    
  rescue
    # Well, we just won't worry about that now, will we?  
  end          

  def success(url, feed)
    logger.debug "Successfully parsed feed"
    feed.sanitize_entries!
    self.etag = feed.etag
    self.last_modified = feed.last_modified        
    process(feed.entries)
    save
  end  
  
  def failure(*params)
    puts "No updates available or failed to parse: #{params.to_yaml}"
  end

  # Process all of the items in order after the last known item 
  def process(items)
    found = false
    to_process = items.select {|item| found ||= (item.checksum == self.checksum) }
    to_process.blank? ? to_process = items : to_process.shift
    to_process.each {|entry| store(entry) }
  end
  
  def store(entry)
    checksum = entry.checksum  
    # This is probably slower than it should be and maybe not needed
    return if Entry.count(:conditions => ['checksum = ?', checksum]) > 0
    self.checksum = checksum
    self.entries.create(
      :checksum => self.checksum,
      :title => entry.title,
      :url => entry.url,
      :author => entry.author,
      :summary => entry.summary,
      :content => entry.content,
      :published_at => entry.published,
      :categories => entry.categories.join(", ")
    )  
  end
end

