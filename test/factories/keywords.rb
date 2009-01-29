Factory.sequence :keyword do |n|
  "Word#{n}"
end

Factory.define :keyword, :class => 'keyword' do |keyword|
  keyword.word         { Factory.next :keyword }
  keyword.description  { "The magic word." }
  keyword.language     { "en" }
  keyword.channel      {|keyword| keyword.association(:channel) }
end
