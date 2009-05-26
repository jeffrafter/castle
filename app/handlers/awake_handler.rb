module Message
  class AwakeHandler < AbstractHandler
    def run
      command = Command.parse(self.message)
      return unless command && command.key == 'wake'
      hour = command.args.first.compact rescue "0"
      hour = hour.to_i rescue 0
      if (hour > 0)
        self.user.awake = hour
        self.user.save!
        reply I18n.t(:wake, :time => "%02d:00" % hour)
      else
        reply I18n.t(:how_to_wake)
      end  
      halt
    end
  end
end