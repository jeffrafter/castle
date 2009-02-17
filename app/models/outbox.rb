class Outbox < ActiveRecord::Base
  set_table_name 'outbox'
  belongs_to :gateway
end
