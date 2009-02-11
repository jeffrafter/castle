class Command 
  attr_accessor :number, :command, :message, :keyword
  
  def initialize(params) 
    self.number = params[:number]
    self.command = params[:command]
    self.message = params[:message]
    self.keyword = params[:command].downcase.to_sym # todo, handle traslations for keys
  end
end
