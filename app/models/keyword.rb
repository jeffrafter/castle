class Keyword < ActiveRecord::Base
  belongs_to :channel
  validates_presence_of :word, :language, :channel
end
