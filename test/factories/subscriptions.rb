Factory.define :subscription, :class => 'subscription' do |subscription|
  subscription.number_per_day { 5 }
  subscription.channel {|channel| channel.association(:channel) }
  subscription.user {|user| user.association(:user) }
end