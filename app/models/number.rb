class InvalidPhoneNumberError < RuntimeError; end

class Number
  # Right now we don't want any number formatting, let the gateway handle it
  # This is a problem when we receive an invite. So that feature is not perfect.
  def self.validate(number)
    number
  end
end