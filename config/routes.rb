ActionController::Routing::Routes.draw do |map|
  map.resources :messages
  map.resources :entries
  map.resources :channels
  map.resources :keywords
  map.resources :gateways
  map.resources :areas
  map.resources :regions
  map.resources :commands

  map.resources :users, :has_one => [:password, :confirmation]
  map.resource :session, :collection => {:verify => :get}
  map.resources :passwords

  map.api '/api', :controller => 'commands', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.root :controller => 'dashboard'
end
