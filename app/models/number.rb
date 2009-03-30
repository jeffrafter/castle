class InvalidPhoneNumberError < RuntimeError; end

class Number
  def self.validate(number)
    raise InvalidPhoneNumberError.new("Invalid number format #{number}") if number == "500" || number == "+5690" || number == "911" || number == "1121611611" || number == "Movistar"
    number
  end
end