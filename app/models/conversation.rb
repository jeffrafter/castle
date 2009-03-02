class Conversation < ActiveRecord::Base
  belongs_to :user
  has_many :conversation_messages
  has_many :messages, :through => :conversation_messages, :source => :inbox
  validates_presence_of :state, :user, :handler_id
  named_scope :current, lambda {{ :conditions => ['updated_at > ?', 15.minutes.ago] }}
end
