Factory.define :conversation, :class => 'conversation' do |conversation|
  conversation.handler_id   { 1 }
  conversation.state        { 'asked' }
  conversation.user         {|conversation|  conversation.association(:user_with_number)}
  conversation.messages     {|conversation| [conversation.association(:inbox)]}  
end
