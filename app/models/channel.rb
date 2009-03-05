class Channel < ActiveRecord::Base
  named_scope :enabled, :conditions => ['active = ?', true]
  belongs_to :region
  validates_presence_of :keywords
  has_many :feeds
end