FbBase::Application.routes.draw do
  resources :friends, :only => [:index, :show]
  match '/signin' => "sessions#new", :as => :signin
  root :to => 'friends#index'
  match '/:name' => "facebook#page"
end
