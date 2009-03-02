class ConversationMessage < ActiveRecord::Base
  belongs_to :inbox, :class_name => 'Inbox' 
end
