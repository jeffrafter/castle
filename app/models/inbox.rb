class Inbox < ActiveRecord::Base
  set_table_name 'inbox'  
  belongs_to :gateway
  validates_presence_of :number, :gateway, :text
end
