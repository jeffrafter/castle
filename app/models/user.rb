require 'active_record_validations_extension'

class User < ActiveRecord::Base
  include Clearance::App::Models::User
  clear_validations
  validates_presence_of :password, :if => :password_required?
  validates_confirmation_of :password, :if => :password_required?
  validates_presence_of :email, :if => :email_required?
  validates_uniqueness_of :email, :case_sensitive => false, :if => :email_required?
  validates_format_of :email, :with => %r{.+@.+\..+}, :if => :email_required?

  attr_accessible :number, :gateway_id, :locale
  
  has_many :conversations
  has_many :subscriptions
  has_many :deliveries
  
  def password_required?
    number.blank? && (encrypted_password.blank? || !password.blank?)
  end
  
  def email_required?
    number.blank? || email.present?
  end
  
  def validate
    self.number = Number.validate(self.number) if self.number
  rescue InvalidPhoneNumberError
    errors.add(:number, 'is not a valid phone number for this region')
  end
  
  def subscribe(channel_id)
    subscriptions.find_or_create_by_channel_id(channel_id)
  end
  
  def unsubscribe(channel_id)
    subscriptions.find_by_channel_id(channel_id).destroy rescue nil
  end
  
  def tell(text)
    raise "This user has no gateway, message could not be sent" unless gateway_id
    Outbox.create(:gateway_id => gateway_id, :number => number, :text => text)
  end
  
end