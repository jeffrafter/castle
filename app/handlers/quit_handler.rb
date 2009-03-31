module Message
  class QuitHandler < AbstractHandler
    def run
      command = Command.parse(self.message)
      return unless command && command.key == 'quit'
      self.user.deleted_at = Time.now
      self.user.save
      reply I18n.t(:quit)
      halt
    end
  end
end