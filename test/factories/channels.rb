Factory.sequence :channel do |n|
  "Channel#{n}"
end

Factory.define :channel, :class => 'channel' do |channel|
  channel.title        { Factory.next :region }
  channel.subtitle     { "Yellow submarine" }
  channel.link         { "http://xkcd.com/atom.xml" }
  channel.description  { "Something about the cool" }
  channel.author       { "The Yellow Dart" }
  channel.interval     { 42 }
  channel.region       {|region| region.association(:region) }
end