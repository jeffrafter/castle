module Message
  class CommentHandler < AbstractHandler
    def run
      command = Command.parse(self.message)
      return unless command && command.key == 'comment'
      # Currently the comment is only available in the inbox, this is just a path
      reply I18n.t(:comment)
      halt
    end
  end
end