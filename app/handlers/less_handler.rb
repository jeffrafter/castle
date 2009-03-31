module Message
  class LessHandler < AbstractHandler
    def run
      command = Command.parse(self.message)
      return unless command && command.key == 'less'
      arg = '%' + command.args.first.compact + '%'
      channel = Channel.first(:conditions => ['system = ? AND keywords like ?', false, arg])
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