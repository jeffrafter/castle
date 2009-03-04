module Message
  class HelpHandler < AbstractHandler
    def run
      @command = Command.parse(self.message)
      return unless @command.command == :help
      reply I18n.t(:help)
      halt
    end
  end
end