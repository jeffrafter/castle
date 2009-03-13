module Message
  class ChannelsHandler < AbstractHandler
    def run
      @command = Command.parse(self.message)
      return unless @command.command == :channels
      reply self.user.available_text
      halt
    end
  end
end