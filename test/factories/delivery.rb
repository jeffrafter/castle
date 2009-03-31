Factory.sequence :delivery do |n|
  "delivery#{n}"
end

Factory.define :delivery, :class => 'delivery' do |delivery|
  delivery.entry       {|delivery| delivery.association(:entry) }
  delivery.channel     {|delivery| delivery.association(:channel) }
  delivery.user        {|delivery| delivery.association(:user) }
end