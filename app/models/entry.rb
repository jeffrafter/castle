class Entry < ActiveRecord::Base
  belongs_to :channel
  validates_presence_of :channel
  validates_uniqueness_of :link
end
