module Message
  class LocaleHandler < AbstractHandler
    def run
      @command = Command.parse(self.message)
      return unless @command.command == :locale
      arg = @command.args.first.chomp      
      self.user.locale = arg
      self.user.save
      halt
    end
  end
end