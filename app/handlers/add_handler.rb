module Message
  class AddHandler < AbstractHandler
    def run
      @command = Command.parse(self.message)
      return unless @command.command == :add
      arg = @command.args.first.chomp
      keyword = Keyword.find_by_word(arg)
      self.user.subscribe(keyword.channel_id)
      halt
    end
  end
end