class Channel < ActiveRecord::Base
  belongs_to :region
  validates_presence_of :link, :region
end
