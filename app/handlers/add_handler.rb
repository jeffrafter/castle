module Message
  class AddHandler < AbstractHandler
    def run
      @command = Command.parse(self.message)
      return unless @command.command == :add
      arg = '%' + @command.args.first.chomp + '%'
      channel = Channel.first(:conditions => ['keywords like ?', arg])
      self.user.subscribe(channel.id)
      halt
    end
  end
end