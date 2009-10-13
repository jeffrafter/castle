require 'active_record_validations_extension'

class NoGatewayForUserError < RuntimeError; end

class User < ActiveRecord::Base
  include Clearance::User
  clear_validations
  validates_presence_of :password, :if => :password_required?
  validates_confirmation_of :password, :if => :password_required?
  validates_presence_of :email, :if => :email_required?
  validates_uniqueness_of :email, :case_sensitive => false, :if => :email_required?
  validates_format_of :email, :with => %r{.+@.+\..+}, :if => :email_required?
  validates_uniqueness_of :number

  attr_accessible :number, 
    :number_confirmed, 
    :email, 
    :name, 
    :address, 
    :details, 
    :provider, 
    :prepaid, 
    :gateway_id, 
    :locale, 
    :timezone_offset, 
    :sleep, 
    :awake
  
  named_scope :active, :conditions => ['active = ?', true]
  named_scope :available, :conditions => ['deleted_at IS NULL']

  has_many :conversations
  has_many :subscriptions
  has_many :deliveries
  has_many :ratings
  belongs_to :gateway

  def subscriptions_text
    if (self.subscriptions.blank?)
      I18n.t(:not_subscribed)
    else
      index = 0
      text = I18n.t(:subscriptions) + ' '
      text += self.subscriptions.map{|s| "#{s.channel.title}"}.join(", ")
    end  
  end

  def available_text
    raise NoGatewayForUserError unless gateway
    available = gateway.region.channels.available(self.id)
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
  
  def subscribe(channel_id)
    subscription = subscriptions.find_by_channel_id(channel_id)
    return if subscription
    subscription = subscriptions.create(:channel_id => channel_id)
    Delivery.deliver_to(subscription)
  end
  
  def unsubscribe(channel_id)
    subscriptions.find_by_channel_id(channel_id).destroy rescue nil
  end
  
  def tell(text, priority = nil)
    priority ||= PRIORITY[:none]
    raise "This user has no gateway, message could not be sent" unless gateway_id
    Outbox.create(:gateway_id => gateway_id, :number => self.number, :text => text, :priority => priority)
  end
  
  def quiet_hours?
    hour = Time.zone.now.hour + self.timezone_offset
    hour = 24 + hour if hour < 0
    self.awake > hour || hour > self.sleep
  end
  
  def activate
    self.active = true
    self.save
  end

  def deactivate
    self.active = false
    self.save
  end
  
  def confirm
    self.number_confirmed = true
    self.save
  end
  
  def start_of_day(time = Time.zone.now)
    user_time = time + self.timezone_offset.hours
    time - (user_time.hour.hours + user_time.min.minutes + user_time.sec.seconds)
  end
  
end