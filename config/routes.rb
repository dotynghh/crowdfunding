Rails.application.routes.draw do
	root :to => "welcome#index"
  devise_for :users
  get 'welcome/index'

  namespace :admin do
  	root :to => "users#index"
  	resources :users
  	resources :projects
  end
  namespace :user_management do 
    resources :users
  end
end
