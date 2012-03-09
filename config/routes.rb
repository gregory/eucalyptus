FbBase::Application.routes.draw do
  resources :friends, :only => [:index, :show]
  resources :sessions, :only => [:new]
  root :to => 'friends#index'
end
