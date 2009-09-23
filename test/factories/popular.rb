Factory.define :popular, :class => 'popular' do |popular|
  popular.entry       {|popular| popular.association(:entry) }
  popular.channel     {|popular| popular.association(:channel) }
end