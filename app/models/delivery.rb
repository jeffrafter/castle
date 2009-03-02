class Delivery < ActiveRecord::Base
  belongs_to :entry
  belongs_to :user
  belongs_to :channel
  
  def self.deliver(subscription, entry)
    ActiveRecord::Base.transaction do
      delivery = Delivery.create(
        :channel_id => subscription.channel_id, 
        :user_id => subscription.user_id, 
        :entry_id => entry.id)
      delivery.user.tell(entry.message)  
    end  
  end
end