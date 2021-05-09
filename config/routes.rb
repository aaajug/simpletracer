Rails.application.routes.draw do
  resources :establishments
  resources :saved_reports
  resources :logs
  resources :managers

  root to: 'home#index'
  
  get '/manager/login', to: 'managers#login'
  post '/manager/login', to: 'managers#verify'
  get '/manager/logout', to: 'managers#logout' 
  get '/manager/add', to: 'managers#new'
  get '/manager/overview', to: 'managers#index'
  get '/manager/accounts', to: 'managers#list'
  get '/manager/:name/logs', to: 'logs#list'
  post '/manager/:name/logs', to: 'logs#list'
  post '/manager/trace', to: 'managers#findByMail'

  get '/establishment/login', to: 'establishments#login'
  post '/establishment/login', to: 'establishments#verify'
  get '/establishment/logout', to: 'establishments#logout'
  get '/establishment/add', to: 'establishments#new'
  get '/establishment/:name', to: 'establishments#index'
  get '/:name/logs', to: 'logs#list'
  get '/:name/trace', to: 'logs#trace'
  post '/:name/trace', to: 'logs#create'

  post '/logs/daterange', to: 'logs#daterange'
  post '/initalize', to: 'managers#initialize'

  get '/logs/view', to: 'logs#index'
end
