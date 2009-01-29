class Gateway < ActiveRecord::Base
  named_scope :enabled, :conditions => 'active = 1'
  belongs_to :region
  validates_presence_of :number, :region
end
