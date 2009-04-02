module Message
  class ListHandler < AbstractHandler
    def run
      command = Command.parse(self.message)
      return unless command && command.key == 'list'
      reply ["#{user.subscriptions_text}", "#{user.available_text}"].join("; ")
      halt
    end
  end
end