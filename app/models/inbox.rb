class Inbox < ActiveRecord::Base
  set_table_name 'inbox'  
  before_create :verify_number
  
  def verify_number
    self.number = Number.validate(self.number)
  end
  
end
