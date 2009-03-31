class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :channel
  validates_presence_of :user, :channel
  
  def more
    self.number_per_day += 5
    self.save
    Delivery.deliver_to(self)
  end
  
  def less
    self.number_per_day -= 5
    self.number_per_dat = 0 if self.number_per_day < 0
    self.save
  end
  
  def none
    self.number_per_dat = 0
    self.save
  end
end