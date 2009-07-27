class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :entry
  belongs_to :region
  
  validates_uniqueness_of :entry_id, :scope => :user_id
  
  def validate
    channel = self.entry.feed.channel rescue nil
    errors.add(:entry, "Entry must belong to a channel") unless channel
  end
end
