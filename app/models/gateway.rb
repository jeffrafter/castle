class InvalidPhoneNumberError < RuntimeError; end

class Gateway < ActiveRecord::Base
  named_scope :enabled, :conditions => ['active = ?', true]
  belongs_to :region
  validates_presence_of :number, :region, :locale, :timezone_offset
  before_create :generate_key

  def format_number(number)
    Number.validate(self.number) if self.number
    
#    re = Regexp.new("^#{number_format}$")
#    number = clean_number(number)
#    raise InvalidPhoneNumberError.new("Invalid number format #{number}") unless re.match(number)
#    number
  end
  
private 
  
#  def clean_number(number)
#    number = number.gsub(/[^0-9]/, '')
#    number = number.gsub(/^#{country_code}/, '')
#    number  
#  end

  def generate_key
    self.api_key ||= Digest::SHA512.hexdigest("--#{Time.now.utc.to_s}--#{number}--")
    self.api_key_expires_at = nil              
  end
end
