class Channel < ActiveRecord::Base
  named_scope :enabled, :conditions => ['active = ?', true]
  belongs_to :region
  validates_presence_of :keywords
  has_many :feeds
  
  named_scope :available, lambda {|user_id| {
    :joins => "LEFT OUTER JOIN subscriptions ON subscriptions.user_id = #{user_id} AND subscriptions.channel_id = channels.id", 
    :conditions => ['subscriptions.id IS NULL']
  }}
end