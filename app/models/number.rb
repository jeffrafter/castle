class InvalidPhoneNumberError < RuntimeError; end

class Number
  def self.validate(number)
    number.gsub!(/[^0-9]/, '')
    number = number.slice(1, number.length) if number =~ /^1/    
    raise InvalidPhoneNumberError.new "Invalid number format #{number}" unless number.length == 10
    number
  end
end
