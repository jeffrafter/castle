module Message
  class CarsHandler < AbstractHandler
    def run
      @command = Command.parse(self.message)
      return unless @command.command == :cars
      reply "1:Buick (3), 2:Mustang (1) reply with 1 or 2 for more info"
      halt
    end
  end
end