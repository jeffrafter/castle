Factory.sequence :command do |n|
  "command#{n}"
end

Factory.define :command, :class => 'command' do |command|
  command.word          { Factory.next :command }
  command.key           { 'key' }
  command.locale        { 'en' }
end