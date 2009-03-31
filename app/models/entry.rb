class Entry < ActiveRecord::Base
  belongs_to :feed
  validates_presence_of :feed
  named_scope :unprocessed, :conditions => ['processed = ?', false], :include => :feed

  # Most recent entries for this channel and user that have not already been delivered 
  # TODO make this query only grab the latest since the last received item
  # TODO the joins might alter the limit if an entry is delivered to a user more than once
  named_scope :available, lambda {|user_id, channel_id, limit|   
    h = {}
    h[:include] = :feed 
    h[:joins] = "LEFT OUTER JOIN deliveries ON deliveries.entry_id = entries.id AND deliveries.user_id = #{user_id}"
    h[:conditions] = ['feeds.channel_id = ? AND deliveries.id IS NULL', channel_id]
    h[:order] = 'entries.created_at DESC' 
    h[:limit] = limit unless limit == :all
    h      
  } 
  
  def before_save
    text = "\"#{title}\" #{[summary, content].join(' ')}".compact
    text = text[0..140]
    self.message = text
  end
  
end