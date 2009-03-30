class Outbox < ActiveRecord::Base
  set_table_name 'outbox'
  belongs_to :gateway
  validates_presence_of :number, :gateway, :text

  def validate
    self.number = Number.validate(self.number) unless self.number.blank?
  rescue InvalidPhoneNumberError
    self.errors.add(:number, 'is not a valid number')  
  end
end