module Message
  class HelpHandler < AbstractHandler
    def run
      @command = Command.parse(self.message)
      return unless @command.command == :help
      reply 'Commands: channels, add, remove, list, more, less, invite, help'
      halt
    end
  end
end