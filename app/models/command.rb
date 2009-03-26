class InvalidCommandError < RuntimeError; end

class Command < ActiveRecord::Base
  validates_presence_of :locale, :key, :word
  
  attr_accessor :command, :args
  
  def self.parse(message)
    args = message[:text].split(/\s/)    
    command = args.shift
    record = Command.first(:conditions => ['word LIKE ?', '%' + command + '%'])
    return nil unless record
    record.command = command
    record.args = args
    record
  end
end
