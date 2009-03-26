Factory.sequence :gateway do |n|
  "123456789#{n}"
end

Factory.sequence :api_key do |n|
  "987654321#{n}"
end

Factory.define :gateway, :class => 'gateway' do |gateway|
  gateway.number          { Factory.next :gateway }
  gateway.api_key         { Factory.next :api_key }
  gateway.short_code      { 12345 }
  gateway.country_code    { 1 }
  gateway.area_code       { 35 }
  gateway.timezone_offset { -8 }
  gateway.locale          { "en" }
  gateway.region          {|region| region.association(:region) }
end