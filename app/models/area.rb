class Area < ActiveRecord::Base
  belongs_to :region
  validates_presence_of :name, :country_code, :area_code, :region
end
