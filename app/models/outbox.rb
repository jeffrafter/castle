require 'textmagic'

class Outbox < ActiveRecord::Base
  set_table_name 'outbox'
  belongs_to :gateway
  validates_presence_of :number, :gateway, :text  
  named_scope :local, lambda {|gateway_id| { :conditions => ['gateway_id = ?', gateway_id]}}
  after_create :send
  
  def send
    if gateway.textmagic_username.present?
      begin
        api = TextMagic::API.new(gateway.textmagic_username, gateway.textmagic_password)
        identifier = api.send(self.text, "#{self.number.gsub(/[^0-9]/,'')}")
        self.update_attributes(:identifier => identifier)
      rescue Exception => e
        puts "Could not send message using textmagic (#{e})"  
      end
    end
  end  
end