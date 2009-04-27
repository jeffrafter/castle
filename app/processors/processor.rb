class UserNotActiveError < RuntimeError; end

module Message
  class Processor
    attr_reader :message, :gateway, :user, :conversation

    def initialize(message)
      @conversation = nil
      @message = message
      @gateway = message.gateway
      @user = User.available.find_by_number(@message.number)
    end
    
    def run 
      until_halted do
        handle_user
        handle_conversation
        handle_command
        handle_unknown
      end  
    rescue Exception => e
      puts "Error attempting to process message #{e.message} (#{e.backtrace.join("\n")}"
    end
    
    def reply(text)
      say(text, @message.number, PRIORITY[:high])
    end
    
    def say(text, number, priority = nil)
      priority ||= PRIORITY[:low]
      Outbox.create(:text => text, :number => number, :gateway => @gateway, :priority => priority)        
    end
    
  private

    def handle_user
      I18n.locale = @user.locale if @user
      handle_new_user unless @user
      handle_deactivated_user unless @user.active?
      handle_user_confirmation unless @user && @user.number_confirmed?      
    end
    
    def handle_new_user
      InviteHandler.new(self).invite(@message.number, @gateway.id, @gateway.locale, @gateway.timezone_offset)
      halt
    end

    def handle_deactivated_user    
      raise UserNotActiveError.new("User deactivated")
    end

    def handle_user_confirmation
      command = Command.parse(@message)
      if command.blank?
        reply I18n.t(:invite, :locale => @gateway.locale)      
      elsif command.key == 'yes'
        reply I18n.t(:join) + ' ' + I18n.t(:help)
        reply I18n.t(:join_commands)
        reply @user.available_text
        @user.number_confirmed = true
        @user.save!
      elsif command.key == 'no'
        # Do nothing if they say no
      else
        reply I18n.t(:invite, :locale => @gateway.locale)      
      end  
      halt  
    end
    
    def handle_conversation
      @conversation = @user.conversations.current
      if (@conversation)
        HANDLERS.each do |klass|
          handler = klass.new(self)
          handler.continue
        end
      end
    end
    
    def handle_command
      HANDLERS.each do |klass|
        begin
          handler = klass.new(self)
          handler.run
        rescue Exception => e
          raise "There was an error handling the message with handler #{klass.name}: #{e.message}"
        end  
      end
    end
    
    def handle_unknown
      reply "#{I18n.t(:unknown_command)} #{I18n.t(:help)}; " + ["#{self.user.subscriptions_text}", "#{self.user.available_text}"].join("; ")
      halt
    end  

    def until_halted
      catch :halt do
        yield 
      end    
    end  
    
    def halt
      throw :halt
    end
    
  end
end  