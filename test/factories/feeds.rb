Factory.sequence :feed do |n|
  "Feed#{n}"
end

Factory.define :feed, :class => 'feed' do |feed|
  feed.title         { Factory.next :feed }
  feed.subtitle      { "Yellow submarine" }
  feed.feed_url      { "http://www.latercera.com/app/rss?sc=TEFURVJDRVJB&ul=1" }
  feed.url           { "http://www.latercera.com" }
  feed.description   { "La tercera news" }
  feed.last_modified { 15.minutes.ago }
  feed.interval      { 42 }
  feed.channel       { |channel| channel.association(:channel) }
end