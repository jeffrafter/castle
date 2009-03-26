class Entry < ActiveRecord::Base
  belongs_to :feed
  validates_presence_of :feed
  named_scope :unprocessed, :conditions => ['processed = ?', false], :include => :feed

  # Most recent entries for this channel and user that have not already been delivered 
  # TODO make this query only grab the latest since the last received item
  named_scope :available, lambda {|user_id, channel_id, limit| {
    :limit => limit,
    :include => :feed, 
    :joins => "LEFT OUTER JOIN deliveries ON deliveries.entry_id = entries.id AND deliveries.user_id = #{user_id}", 
    :conditions => ['feeds.channel_id = ? AND deliveries.id IS NULL', channel_id],
    :order => 'entries.created_at DESC'       
  }} 
  
  def before_save
    text = "\"#{title}\" #{[summary, content].join(' ')}".compact
    text = text[0..140]
    self.message = text
  end
  
end