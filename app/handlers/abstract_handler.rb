module Message
  class AbstractHandler
    attr_accessor :processor
  
    def initialize(processor)
      @processor = processor
    end
  
    def run; end

    def continue; end

    # I am thinking this should all be method_missing right?
    
    def say(text, number)
      @processor.say(text, number)
    end
    
    def reply(text)
      @processor.reply(text)
    end
    
    def message
      @processor.message
    end

    def user
      @processor.user
    end
    
    def gateway
      @processor.gateway
    end

    def conversation
      @processor.conversation
    end

  private  
    def halt
      throw :halt
    end    
  end
end