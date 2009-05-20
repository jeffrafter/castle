namespace :db do
  desc "Setup a test region and feed"
  task :bootstrap do
    require File.join(RAILS_ROOT, 'config', 'environment')
    if Region.find_by_name('Test')
      puts "Nothing to do"
    else  
      r = Region.create(:name => 'Test', :country => 'United States')
      g = r.gateways.create(:locale => 'en', :number => '2022159819', :api_key => '7c28db9f8a0e10ab5101d5c53ef44035890c77c8b53ea2587c4d4aa85728ae49475bf09065624dae9d3442eb211bd87915cdd494cf3774127cc5dcea6339f4dd', :active => true, :timezone_offset => -5)
      c = r.channels.create(:title => 'World', :keywords => 'world')
      f = c.feeds.create(:feed_url => 'http://news.google.com/news?ned=us&topic=w&output=rss')  
      u = User.create(
        :number => '6507991415', 
        :email => 'njero@njero.com', 
        :password => 'njero', 
        :confirm_password => 'njero',
        :gateway_id => 1,
        :timezone_offset => -5,
        :locale => 'en')
      u.email_confirmed = true
      u.number_confirmed = true
      u.save!
      u.subscribe(c.id)
    end  
  end
  
  desc "Setup the default commands"
  task :commands do
    require File.join(RAILS_ROOT, 'config', 'environment')
    Command.create(:word => 'yes', :key => 'yes', :locale => 'en')
    Command.create(:word => 'no', :key => 'no', :locale => 'en')
    Command.create(:word => 'add', :key => 'add', :locale => 'en')
    Command.create(:word => 'remove', :key => 'remove', :locale => 'en')
    Command.create(:word => 'del', :key => 'remove', :locale => 'en')
    Command.create(:word => 'wake', :key => 'wake', :locale => 'en')
    Command.create(:word => 'awake', :key => 'wake', :locale => 'en')
    Command.create(:word => 'sleep', :key => 'sleep', :locale => 'en')
    Command.create(:word => 'more', :key => 'more', :locale => 'en')
    Command.create(:word => 'less', :key => 'less', :locale => 'en')
    Command.create(:word => 'list', :key => 'list', :locale => 'en')
    Command.create(:word => 'channels', :key => 'channels', :locale => 'en')
    Command.create(:word => 'help', :key => 'help', :locale => 'en')
    Command.create(:word => 'invite', :key => 'invite', :locale => 'en')
    Command.create(:word => 'locale', :key => 'locale', :locale => 'en')
    Command.create(:word => 'language', :key => 'locale', :locale => 'en')
    Command.create(:word => 'quit', :key => 'quit', :locale => 'en')
    Command.create(:word => 'stop', :key => 'quit', :locale => 'en')
    Command.create(:word => 'comment', :key => 'comment', :locale => 'en')
    Command.create(:word => 'rate', :key => 'rate', :locale => 'en')
    Command.create(:word => 'like', :key => 'rate', :locale => 'en')
    Command.create(:word => 'fav', :key => 'rate', :locale => 'en')
        
    Command.create(:word => 'sí', :key => 'yes', :locale => 'es')
    Command.create(:word => 'si', :key => 'yes', :locale => 'es')
    Command.create(:word => 'no', :key => 'no', :locale => 'es')
    Command.create(:word => 'anadir', :key => 'add', :locale => 'es')
    Command.create(:word => 'remover', :key => 'remove', :locale => 'es')
    Command.create(:word => 'sacar', :key => 'remove', :locale => 'es')
    Command.create(:word => 'eliminar', :key => 'remove', :locale => 'es')
    Command.create(:word => 'alerta', :key => 'wake', :locale => 'es')
    Command.create(:word => 'vigilante', :key => 'wake', :locale => 'es')
    Command.create(:word => 'suspendido', :key => 'sleep', :locale => 'es')
    Command.create(:word => 'más', :key => 'more', :locale => 'es')
    Command.create(:word => 'mas', :key => 'more', :locale => 'es')
    Command.create(:word => 'menos', :key => 'less', :locale => 'es')
    Command.create(:word => 'lista', :key => 'list', :locale => 'es')
    Command.create(:word => 'fuente', :key => 'channels', :locale => 'es')
    Command.create(:word => 'ayuda', :key => 'help', :locale => 'es')
    Command.create(:word => 'invita', :key => 'invite', :locale => 'es')
    Command.create(:word => 'locale', :key => 'locale', :locale => 'es')
    Command.create(:word => 'lenguaje', :key => 'locale', :locale => 'es')
    Command.create(:word => 'salir', :key => 'quit', :locale => 'es')
    Command.create(:word => 'detener', :key => 'quit', :locale => 'es')
    Command.create(:word => 'cerrar', :key => 'quit', :locale => 'es')
    Command.create(:word => 'gusta', :key => 'rate', :locale => 'es')
    Command.create(:word => 'gusto', :key => 'rate', :locale => 'es')
    Command.create(:word => 'comentar', :key => 'comment', :locale => 'es')
  end
end