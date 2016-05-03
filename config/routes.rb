Rails.application.routes.draw do
  # Routes for main resources
  resources :stores
  resources :employees
  resources :assignments   
  resources :sessions
  resources :shifts
  resources :flavors
  resources :jobs
  
  #get 'user/edit' => 'users#edit', :as => :edit_current_user
  #get 'signup' => 'users#new', :as => :signup
  get 'login' => 'sessions#new', :as => :login
  get 'logout' => 'sessions#destroy', :as => :logout

  # Semi-static page routes
  get 'home' => 'home#home', as: :home
  get 'about' => 'home#about', as: :about
  get 'contact' => 'home#contact', as: :contact
  get 'privacy' => 'home#privacy', as: :privacy

  get 'future_shifts' => 'shifts#future_shifts', :as => :future_shifts
  get 'past_shifts' => 'shifts#past_shifts', :as => :past_shifts
  
  get 'start_now/:id' => 'shifts#start_now', :as => :start_now
  get 'end_now/:id' => 'shifts#end_now', :as => :end_now


  # Set the root url
  root :to => 'home#home'  
  
end
