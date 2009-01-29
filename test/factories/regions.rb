Factory.sequence :region do |n|
  "Region#{n}"
end

Factory.define :region, :class => 'region' do |region|
  region.name     { Factory.next :region }
  region.country  { "Texas" }
  region.language { "en" }
end