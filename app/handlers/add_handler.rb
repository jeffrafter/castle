module Message
  # AddHandler is the last in the chain, so we also try to handle commands
  # like method missing. If there is no command treat the numbers or text
  # as channel requests. If there are no matching channels, then we give up.
  class AddHandler < AbstractHandler
    def run
      command = Command.parse(self.message)
      available_channels = self.gateway.region.channels.available(self.user.id).all
      if command && command.key == 'add'
        return unless add_subscriptions(command.args, available_channels)
      else
        return unless add_subscriptions(self.message[:text].split(/\s+/), available_channels)
      end
      halt
    end
    
    def add_subscriptions(args, available_channels)
      requested_channels = []
      args.each {|arg|
        re = Regexp.new(arg.downcase)
        requested_channels << available_channels.select{|c| c.title.downcase =~ re || c.keywords.downcase =~ re }.first
      }
      requested_channels.compact!    
      requested_channels.each {|channel|
        self.user.subscribe(channel.id)
        reply I18n.t(:subscribed, :title => "#{channel.title}", :keyword => "#{channel.title.downcase}")  + ' ' + self.user.subscriptions_text
      }
      !requested_channels.blank?
    end
  end
end