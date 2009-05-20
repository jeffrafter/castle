Factory.sequence :number do |n|
  "+1987654321#{n}"
end

Factory.define :user_with_number, :class => 'user' do |user|
  user.number           { Factory.next :number }
  user.number_confirmed { true }
  user.gateway          {|gateway| gateway.association(:gateway)}
end