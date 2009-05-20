class Popular
  def self.populate(region_id)
    # Lookup the channel where we will add these
    popular = Channel.enabled.first(:conditions => ['region_id = ? AND (popular = ? OR title = ?)', region_id, true, 'Popular'])
    popular_feed = popular.feeds.first rescue nil
    return unless popular && popular_feed
    
    # Find all of the ratings for yesterday, grouped by entry.id, limit 3
    rated = Rating.all(
      :limit => 3, 
      :select => 'region_id, entry_id, count(*) as total', 
      :order => 'count(*) desc', 
      :group => :entry_id, 
      :conditions => ['region_id = ? AND DATE(created_at) > ?', region_id, Date.yesterday])    

    # Add the to the popular channel
    rated.each{|item|
      entry = item.entry
      popular_feed.entries.create(
        :checksum => entry.checksum,
        :title => entry.title,
        :url => entry.url,
        :author => entry.author,
        :summary => entry.summary,
        :content => entry.content,
        :published_at => entry.published_at,
        :categories => entry.categories)    
    }
  end
end