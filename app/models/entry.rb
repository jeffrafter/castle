class Entry < ActiveRecord::Base
  belongs_to :feed
  validates_presence_of :feed
  validates_uniqueness_of :url
  named_scope :unprocessed, :conditions => ['processed = ?', false], :include => :feed
  
  def before_save
    text = "\"#{title}\" #{summary || content}"
    text = text[0..140]
    self.message = text
  end
end