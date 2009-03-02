module Message
  class ChannelsHandler < AbstractHandler
    def run
      @command = Command.parse(self.message)
      return unless @command.command == :channels
      channels = self.gateway.region.channels
      i = 0
      text = "Channels:\n "
      text += channels.map{|c| "#{i += 1}) #{c.title} (#{c.keywords.first.word})" }.join("\n ")
      reply text
      halt
    end
  end
end