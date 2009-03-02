class Channel < ActiveRecord::Base
  named_scope :enabled, :conditions => ['active = ?', true]
  belongs_to :region
  has_many :feeds
end