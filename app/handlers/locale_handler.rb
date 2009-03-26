module Message
  class LocaleHandler < AbstractHandler
    def run
      command = Command.parse(self.message)
      return unless command and command.key == 'locale'
      arg = command.args.first.compact      
      self.user.locale = arg
      self.user.save
      reply I18n.t(:locale, :language => arg)
      halt
    end
  end
end