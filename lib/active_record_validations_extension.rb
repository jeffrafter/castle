module ActiveRecord
  class Base
    def self.clear_validations
      @validate_callbacks = []
    end  
  end
end  