module Message
  class AwakeHandler < AbstractHandler
    def run
      @command = Command.parse(self.message)
      return unless @command.command == :awake
      hour = @command.args.first.chomp
      hour = hour.to_i
      if (hour > 0)
        self.user.awake = hour
        self.user.save!
        reply "Thanks, we will not send any news messages until #{hour}"      
      else
        reply "Please enter a number from 1 to 24"
      end  
      halt
    end
  end
end