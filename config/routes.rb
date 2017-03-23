Rails.application.routes.draw do
	get '/', to: 'search_engine#login'
	get '/home', to: 'search_engine#home', as: 'home'
	get '/search', to: 'search_engine#search'
	get '/show/:id', to: 'search_engine#show', as: 'title'
	post '/log', to: 'search_engine#log', defaults: { format: 'json' }
	get '/data/:filename', to: 'search_engine#parse_data'
end
