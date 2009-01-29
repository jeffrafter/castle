Factory.sequence :entry do |n|
  "Entry#{n}"
end

Factory.sequence :entry_link do |n|
  "http://xkcd.com/#{n}"
end

Factory.define :entry, :class => 'entry' do |entry|
  entry.title        { Factory.next :entry }
  entry.link         { Factory.next :entry_link }
  entry.summary      { "The were these monkeys jumping on the bed. Bad news." }
  entry.author       { "Mother Goose" }
  entry.contributor  { "Rudyard Kipling" }
  entry.description  { "An entry from a blawg" }
  entry.content      { "5 little monkeys jumping on the bed. All fell off." }
  entry.category     { "Children's poem" }
  entry.uuid         { "60a76c80-d399-11d9-b91C-0003939e0af6" }
  entry.published_at { Time.now }
  entry.updated_at   { nil }
  entry.expires_at   { Time.now + 1.day }
  entry.channel      {|entry| entry.association(:channel) }
end
