class InvalidCommandError < RuntimeError; end

class Command 
  attr_accessor :number, :command, :text, :arguments, :keyword
  
  def initialize(params) 
    self.number = params[:number]
    self.text = params[:text]
    arr = self.text.split(/\s/)    
    self.command = arr.shift
    self.arguments = self.text.slice(self.command.length + 1, self.text.length)
    self.keyword = self.command.downcase.to_sym 
    raise InvalidCommandError.new "You have sent an invalid command" unless [:invite, :help].include? self.keyword    
  end
end
