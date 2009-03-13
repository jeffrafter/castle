module Message
  class RemoveHandler < AbstractHandler
    def run
      @command = Command.parse(self.message)
      return unless @command.command == :remove
      arg = '%' + @command.args.first.compact + '%'
      channel = Channel.first(:conditions => ['keywords like ?', arg])
      unless channel
        # that channel does not exist
        halt
      end      
      self.user.unsubscribe(channel.id)
      reply I18n.t(:unsubscribed, :title => "#{channel.title}", :keyword => "#{channel.title.downcase}") + ' ' + self.user.subscriptions_text
      halt
    end
  end
end