class Channel < ActiveRecord::Base
  belongs_to :region
  validates_presence_of :keywords
  has_many :feeds
  
  named_scope :available, lambda {|user_id| {
    :joins => "LEFT OUTER JOIN subscriptions ON subscriptions.user_id = #{user_id} AND subscriptions.channel_id = channels.id", 
    :conditions => ['subscriptions.id IS NULL AND system = ? AND active = ?', false, true]
  }}
  
  named_scope :enabled, :conditions => ['active = ?', true]
  named_scope :system, :conditions => ['system = ? AND active = ?', true, true]
end