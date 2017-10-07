Rails.application.routes.draw do

	devise_for :users
	root 'tasks#index'

	get 'tasks/index'
	post 'tasks/index'

	get 'tasks/action'
	post 'tasks/action'
	post 'tasks/tasks/action' => 'tasks#action'
	get 'tasks/result'  => 'tasks#result'
	post 'tasks/update' => 'tasks#update'
	get 'tasks/trend'  => 'tasks#trend'

	resources(:tasks)
	
# get    'tasks'     => 'tasks#index'
# get    'tasks/:id' => 'tasks#show'
# get    'tasks/new' => 'tasks#new'
# post   'tasks'     => 'tasks#create'
# get    'tasks/:id/edit' => 'tasks#edit'
# delete 'tasks/:id' => 'tasks#destroy'
# put    'tasks/:id' => 'tasks#update'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
