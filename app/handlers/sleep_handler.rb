module Message
  class SleepHandler < AbstractHandler
    def run
      @command = Command.parse(self.message)
      return unless @command.command == :sleep
      hour = @command.args.first.chomp
      hour = hour.to_i
      if (hour > 0)
        self.user.sleep = hour
        self.user.save!
        reply "Thanks, we will not send any news messages after #{hour}"      
      else
        reply "Please enter a number from 1 to 24"
      end  
      halt
    end
  end
end