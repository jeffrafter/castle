module Message
  class RemoveHandler < AbstractHandler
    def run
      @command = Command.parse(self.message)
      return unless @command.command == :remove
      arg = '%' + @command.args.first.chomp + '%'
      channel = Channel.first(:conditions => ['keywords like ?', arg])
      unless channel
        # that channel does not exist
        halt
      end      
      self.user.unsubscribe(channel.id)
      reply "You are no longer subscribed to #{channel.title}, to add this channel reply with 'add #{channel.title}'." 
      halt
    end
  end
end