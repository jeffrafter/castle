module Message
  class MoreHandler < AbstractHandler
    def run
      @command = Command.parse(self.message)
      return unless @command.command == :more
      arg = @command.args.first.chomp
      keyword = Keyword.find_by_word(arg)
      subscription = self.user.subscriptions.find_by_channel_id(keyword.channel_id)
      subscription.more if subscription
      halt
    end
  end
end