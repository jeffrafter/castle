Factory.sequence :inbox do |n|
  "Text #{n}"
end

Factory.define :inbox, :class => 'inbox' do |inbox|
  inbox.text          { Factory.next :inbox }
  inbox.number        { Factory.next :number }
  inbox.gateway       {|gateway| gateway.association(:gateway) }
end