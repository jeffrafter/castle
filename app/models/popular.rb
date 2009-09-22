class Popular < ActiveRecord::Base
  set_table_name 'popular'
  belongs_to :entry
  belongs_to :channel
  
  validates_uniqueness_of :entry_id

  def self.total(entry_id, channel_id)
    # Is this message already popular?
    return if self.find_by_entry_id(entry_id)
    # Does it have the votes?
    return unless Rating.count(:conditions => ['entry_id = ?', entry_id]) >= 5    
    # Create it
    self.create(:entry_id => entry_id, :channel_id => channel_id)
  end
end