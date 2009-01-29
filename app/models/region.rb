class Region < ActiveRecord::Base
  named_scope :enabled, :conditions => 'active = 1'
  has_many :areas
  has_many :gateways
  has_many :channels
  validates_presence_of :name, :country, :language
  validates_uniqueness_of :name, :case_sensitive => false, :scope => :language
end
