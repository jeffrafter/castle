class Gateway < ActiveRecord::Base
  named_scope :enabled, :conditions => ['active = ?', true]
  belongs_to :region
  validates_presence_of :number, :region
end
