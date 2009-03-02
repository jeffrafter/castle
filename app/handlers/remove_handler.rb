module Message
  class RemoveHandler < AbstractHandler
    def run
      @command = Command.parse(self.message)
      return unless @command.command == :remove
      arg = @command.args.first.chomp
      keyword = Keyword.find_by_word(arg)
      self.user.unsubscribe(keyword.channel_id)
      halt
    end
  end
end