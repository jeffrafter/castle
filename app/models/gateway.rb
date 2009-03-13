class Gateway < ActiveRecord::Base
  named_scope :enabled, :conditions => ['active = ?', true]
  belongs_to :region
  validates_presence_of :number, :region, :locale, :timezone_offset
  before_create :generate_key
  
private
  def generate_key
    self.api_key ||= Digest::SHA512.hexdigest("--#{Time.now.utc.to_s}--#{number}--")
    self.api_key_expires_at = nil              
  end
end
