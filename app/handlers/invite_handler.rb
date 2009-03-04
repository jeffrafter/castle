module Message
  class InviteHandler < AbstractHandler
    def run
      @command = Command.parse(self.message)
      return unless @command.command == :invite
      return unless @command.args.size == 1
      number = @command.args.first.chomp
      begin
        number = Number.validate(number)
      rescue
        reply I18n.t(:invalid_number)
        halt
      end  
      invite number, self.gateway.id
      halt
    end
  
    def invite(number, gateway_id)
      if User.create(:number => number, :gateway_id => gateway_id, :locale => self.gateway.locale) 
        say I18n.t(:invite, :locale => self.gateway.locale), number
      end  
    end
  end
end