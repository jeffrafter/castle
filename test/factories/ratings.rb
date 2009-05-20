Factory.define :rating, :class => 'rating' do |rating|
  rating.entry       {|rating| rating.association(:entry) }
  rating.user        {|rating| rating.association(:user) }
  rating.created_at  { Date.yesterday }
end