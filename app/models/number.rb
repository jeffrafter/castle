class InvalidPhoneNumberError < RuntimeError; end

class Number
  def self.validate(number)
    format_number(number)
  end
  
private

  def self.country_code
    56
  end
  
  def self.format_number(number)
    return number if (number == "+19519020972" || number == "+16507991415" || number == "+16506992355")
    raise InvalidPhoneNumberError.new("Invalid number format #{number}") if number == "500" || number == "+5690" || number == "911" || number == "1121611611" || number == "Movistar"
    re = /\+#{country_code}\d{9}/
    number = clean_number(number)      
    raise InvalidPhoneNumberError.new("Invalid number format #{number}") unless re.match(number)
    number
  end
  
  def self.clean_number(number)
    number = number.gsub(/[^0-9]/, '')
    number = number.gsub(/^#{country_code}/, '')
    number = number.gsub(/^0/, '')
    "+#{country_code}#{number}"
  end
  
end
