require 'active_record_validations_extension'

class User < ActiveRecord::Base
  include Clearance::App::Models::User
  clear_validations
  validates_presence_of :password, :if => :password_required?
  validates_confirmation_of :password, :if => :password_required?
  validates_presence_of :email, :if => :email_required?
  validates_uniqueness_of :email, :case_sensitive => false, :if => :email_required?
  validates_format_of :email, :with => %r{.+@.+\..+}, :if => :email_required?

  attr_accessible :number, :gateway_id, :locale, :timezone_offset, :sleep, :awake
  
  has_many :conversations
  has_many :subscriptions
  has_many :deliveries
  belongs_to :gateway

  def subscriptions_text
    if (self.subscriptions.user.blank?)
      I18n.t(:not_subscribed)
    elsif   
      index = 0
      text = I18n.t(:subscriptions) + ' '
      text += self.subscriptions.user.map{|s| "#{s.channel.title}"}.join(", ")
    end  
  end

  def available_text
    available = self.gateway.region.channels.available(self.id)
    return "" if available.blank?
    index = 0
    text = I18n.t(:channels) + ' '
    text += available.map{|c| "#{c.title}"}.join(", ") + '. '
    text += I18n.t(:how_to_subscribe)
  end
  
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
    subscription = subscriptions.find_by_channel_id(channel_id)
    return if subscription
    subscription = subscriptions.create(:channel_id => channel_id)
    Delivery.deliver_to(subscription)
  end
  
  def unsubscribe(channel_id)
    subscriptions.find_by_channel_id(channel_id).destroy rescue nil
  end
  
  def tell(text)
    raise "This user has no gateway, message could not be sent" unless gateway_id
    Outbox.create(:gateway_id => gateway_id, :number => number, :text => text)
  end
  
  def quiet_hours?
    hour = Time.now.hour + self.timezone_offset
    hour = 24 + hour if hour < 0
    self.awake > hour || hour > self.sleep
  end
  
end