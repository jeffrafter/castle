module Message
  class ListHandler < AbstractHandler
    def run
      @command = Command.parse(self.message)
      return unless @command.command == :list
      channels = self.user.subscriptions.map{|s| s.channel }
      i = 0
      text = "Subscriptions:\n "
      text += channels.map{|c| "#{i += 1}) #{c.title} (#{c.keywords.first.word})" }.join("\n ")
      reply text
      halt
    end
  end
end