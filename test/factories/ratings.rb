Factory.define :rating, :class => 'rating' do |rating|
  rating.entry       {|rating| rating.association(:entry) }
  rating.user        {|rating| rating.association(:user_with_number) }
end