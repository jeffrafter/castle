class InvalidCommandError < RuntimeError; end

class Command 
  attr_accessor :number, :command, :text, :args
  
  def initialize(params) 
    self.number = params[:number]
    self.text = params[:text]
    arr = self.text.split(/\s/)    
    self.command = arr.shift
    self.command = self.command.downcase.to_sym 
    self.args = self.text.slice("#{self.command}".length + 1, self.text.length)
    self.args = self.args.split(/\s/) rescue nil   
  end
  
  def self.parse(message)
    Command.new(:number => message.number, :text => message.text)    
  end
end
