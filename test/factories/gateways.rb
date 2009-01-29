Factory.sequence :gateway do |n|
  "123456789#{n}"
end

Factory.define :gateway, :class => 'gateway' do |gateway|
  gateway.number       { Factory.next :gateway }
  gateway.short_code   { 12345 }
  gateway.country_code { 56 }
  gateway.area_code    { 35 }
  gateway.region       {|region| region.association(:region) }
end