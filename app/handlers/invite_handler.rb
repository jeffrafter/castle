module Message
  class InviteHandler < AbstractHandler
    def run
      command = Command.parse(self.message)
      return unless command
      return unless command.key == 'invite'
      return unless command.args.length == 1
      number = command.args.first.compact
      begin
        number = self.gateway.format_number(number)        
      rescue
        reply I18n.t(:invalid_number)
        halt
      end  
      invite(number, self.gateway.id, self.gateway.locale, self.gateway.timezone_offset)
      halt
    end
  
    def invite(number, gateway_id, locale, timezone_offset)
      if self.user && self.user.number != number
        reply I18n.t(:invited) + " #{number}"
      end
      if User.create(
        :number => number, 
        :gateway_id => gateway_id, 
        :locale => locale, 
        :timezone_offset => timezone_offset) 
        say I18n.t(:invite, :locale => self.gateway.locale), number
      end  
    end
  end
end