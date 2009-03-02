require 'feedzirra'

module Feedzirra
  module FeedEntryUtilities
    module Sanitize
      def sanitize
        s = self.gsub(/\>/, "> ")
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
    end      
  end
end

class Feed < ActiveRecord::Base
  belongs_to :channel
  has_many :entries
  validates_presence_of :feed_url
  named_scope :enabled, :conditions => ['active = ?', true]
  named_scope :stale, lambda {{ :conditions => ['stale_at < ? OR stale_at IS NULL', Time.now] }}
  before_create :setup
    
  def fetch
    self.stale_at = Time.now + self.interval.minutes
    feed = Feedzirra::Feed.fetch_and_parse(self.feed_url, 
      :if_modified_since => self.last_modified,
      :if_none_match => self.etag,
      :on_success => method(:success),
      :on_failure => method(:failure))
  end

private

  def setup   
    feed = Feedzirra::Feed.fetch_and_parse(self.feed_url)
    self.title ||= feed.title
    self.url ||= feed.url
    self.etag = feed.etag
    self.last_modified = feed.last_modified    
  rescue
    # Well, we just won't worry about that now, will we?  
  end          

  def success(url, feed)
    feed.sanitize_entries!
    self.etag = feed.etag
    self.last_modified = feed.last_modified        
    process(feed.entries)
    save
  end  
  
  def failure(url, feed)
  end

  def process(items)
    # Process all of the items in order after the last known item 
    last_entry = items.find_index {|entry| entry.checksum == self.checksum } if self.checksum
    items = items[last_entry + 1, entries.size] if last_entry
    items.each {|entry| store(entry) }
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

