module Message
  class ListHandler < AbstractHandler
    def run
      command = Command.parse(self.message)
      return unless command && command.key == 'list'
      reply ["#{self.user.subscriptions_text}", "#{self.user.available_text}"].join("; ")
      halt
    end
  end
end