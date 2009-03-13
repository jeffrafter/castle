module Message
  class LessHandler < AbstractHandler
    def run
      @command = Command.parse(self.message)
      return unless @command.command == :less
      arg = '%' + @command.args.first.compact + '%'
      channel = Channel.first(:conditions => ['keywords like ?', arg])
      unless channel
        # that channel does not exist
        halt
      end      
      subscription = self.user.subscriptions.find_by_channel_id(channel.id)
      subscription.less if subscription
      halt
    end
  end
end