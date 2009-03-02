Factory.sequence :outbox do |n|
  "Text #{n}"
end

Factory.define :outbox, :class => 'outbox' do |outbox|
  outbox.text          { Factory.next :outbox }
  outbox.number        { Factory.next :number }
  outbox.gateway       {|gateway| gateway.association(:gateway) }
end