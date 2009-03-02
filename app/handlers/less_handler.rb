module Message
  class LessHandler < AbstractHandler
    def run
      @command = Command.parse(self.message)
      return unless @command.command == :less
      arg = @command.args.first.chomp
      keyword = Keyword.find_by_word(arg)
      subscription = self.user.subscriptions.find_by_channel_id(keyword.channel_id)
      subscription.less if subscription
      halt
    end
  end
end