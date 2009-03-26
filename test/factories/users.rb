Factory.sequence :number do |n|
  "+19876543210"
end

Factory.define :user_with_number, :class => 'user' do |user|
  user.number           { Factory.next :number }
  user.number_confirmed { true }
  user.gateway          {|gateway| gateway.association(:gateway)}
end