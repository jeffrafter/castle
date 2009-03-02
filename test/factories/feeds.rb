Factory.sequence :feed do |n|
  "Feed#{n}"
end

Factory.define :feed, :class => 'feed' do |feed|
  feed.title         { Factory.next :feed }
  feed.subtitle      { "Yellow submarine" }
  feed.feed_url      { "http://xkcd.com/atom.xml" }
  feed.url           { "http://xkcd.com" }
  feed.description   { "Something about the awesome." }
  feed.last_modified { 15.minutes.ago }
  feed.interval      { 42 }
  feed.channel       {|channel| channel.association(:channel) }
end