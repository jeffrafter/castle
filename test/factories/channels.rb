Factory.sequence :channel do |n|
  "Channel#{n}"
end

Factory.define :channel, :class => 'channel' do |channel|
  channel.title        { Factory.next :channel }
  channel.subtitle     { "Yellow submarine" }
  channel.description  { "Something about the cool" }
  channel.keywords     { "yellow, cool" }
  channel.region       {|channel| channel.association(:region) }
end