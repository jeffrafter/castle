namespace :db do
  desc "Setup a test region and feed"
  task :bootstrap do
    require File.join(RAILS_ROOT, 'config', 'environment')
    r = Region.create(:name => 'Test', :country => 'United States')
    g = r.gateways.create(:locale => 'en', :number => '2022159819', :api_key => '7c28db9f8a0e10ab5101d5c53ef44035890c77c8b53ea2587c4d4aa85728ae49475bf09065624dae9d3442eb211bd87915cdd494cf3774127cc5dcea6339f4dd', :active => true)
    c = r.channels.create(:title => 'World', :keywords => 'world')
    f = c.feeds.create(:feed_url => 'http://news.google.com/news?ned=us&topic=w&output=rss')  
    u = User.create(
      :number => '9519020972', 
      :email => 'njero@njero.com', 
      :password => 'njero', 
      :confirm_password => 'njero',
      :gateway_id => 1,
      :locale => 'en')
    u.email_confirmed = true
    u.number_confirmed = true
    u.save!
    u.subscribe(c.id)
  end
end