module Message
  class RateHandler < AbstractHandler
    def run
      command = Command.parse(self.message)
      return unless command && command.key == 'rate'
      # Should maybe check that the last delivery was for this region, rare
      delivery = user.deliveries.last
      halt unless delivery
      # Eventually it might be useful to cast per channel if they send a channel name
      Rating.create(:user_id => user.id, :entry_id => delivery.entry_id, :region_id => gateway.region.id)      
      reply I18n.t(:rating)
      halt
    end
  end
end