ActionController::Routing::Routes.draw do |map|
  map.resources :commands

  map.resources :inbox, :as => 'inbox'
  map.resources :outbox, :as => 'outbox'
  map.resources :clickatell, :as => 'clickatell'
  map.resources :entries
  map.resources :channels
  map.resources :keywords
  map.resources :gateways
  map.resources :areas
  map.resources :regions
  map.resources :commands
  map.resources :feeds
  map.resources :log, :as => 'log'

  map.resources :users, :member => {:activate => :post, :deactivate => :post, :confirm => :post, :tell => :post}, :collection => {:register => :post, :invite => :post}

  # I don't like underscores
  map.signup  'signup', :controller => 'clearance/users', :action => 'new'
  map.signin 'signin', :controller => 'clearance/sessions', :action => 'new'
  map.signout 'signout', :controller => 'clearance/sessions', :action => 'destroy', :method => :delete    
  
  map.deliver '/deliver', :controller => 'dashboard', :action => 'deliver'
  map.dashboard '/dashboard', :controller => 'dashboard'

  map.root :controller => 'clearance/sessions', :action => 'new'
end
