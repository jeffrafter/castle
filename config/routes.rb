ActionController::Routing::Routes.draw do |map|
  map.resources :users, :has_one => [:password, :confirmation]
  map.resource :session
  map.resources :passwords
  
  map.login  '/signup', :controller => 'users', :action => 'new'
  map.login  '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.root :controller => 'dashboard'
end
