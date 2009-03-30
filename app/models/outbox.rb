class Outbox < ActiveRecord::Base
  set_table_name 'outbox'
  belongs_to :gateway
  validates_presence_of :number, :gateway, :text
end