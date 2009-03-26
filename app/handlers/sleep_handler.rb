module Message
  class SleepHandler < AbstractHandler
    def run
      command = Command.parse(self.message)
      return unless command && command.key == 'sleep'
      hour = command.args.first.compact
      hour = hour.to_i
      if (hour > 0 && hour < 25)
        self.user.sleep = hour
        self.user.save!
        reply I18n.t(:sleep, :time => "%02d:00" % hour)
      else
        reply I18n.t(:how_to_sleep)
      end  
      halt
    end
  end
end