Rails.application.routes.draw do
	get '/', to: 'search_engine#login'
	get '/home', to: 'search_engine#home'
	get '/search/:page', to: 'search_engine#search', as: 'search'
	get '/show/:id', to: 'search_engine#show', as: 'title'
	post '/log', to: 'search_engine#log', defaults: { format: 'json' }
end
