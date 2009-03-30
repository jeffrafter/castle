Factory.sequence :delivery do |n|
  "delivery#{n}"
end

Factory.define :delivery, :class => 'delivery' do |delivery|
  delivery.region      {|delivery| delivery.association(:region) }
  delivery.channel     {|delivery| delivery.association(:channel) }
  delivery.user        {|delivery| delivery.association(:user) }
end