class Region < ActiveRecord::Base
  named_scope :enabled, :conditions => ['active = ?', true]
  has_many :areas
  has_many :gateways
  has_many :channels
  validates_presence_of :name, :country
  validates_uniqueness_of :name, :case_sensitive => false
    
  def channels_text
    index = 0
    self.channels.user.map{|c| "[#{index += 1}] #{c.title}"}.join(" ")
  end
end
