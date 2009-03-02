Factory.sequence :entry do |n|
  "Entry#{n}"
end

Factory.sequence :entry_url do |n|
  "http://xkcd.com/#{n}"
end

Factory.define :entry, :class => 'entry' do |entry|
  entry.title        { Factory.next :entry }
  entry.url          { Factory.next :entry_url }
  entry.message      { "5 ltl monkeys. txt me." }
  entry.summary      { "The were these monkeys jumping on the bed. Bad news." }
  entry.author       { "Mother Goose" }
  entry.content      { "5 little monkeys jumping on the bed. All fell off." }
  entry.categories   { "Children's poem" }
  entry.published_at { 1.day.ago }
  entry.feed         {|entry| entry.association(:feed) }
end
