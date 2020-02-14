Rails.application.routes.draw do
  post '/issues/events' => 'events#create', as: :issue_events_create
  get '/issues/:number/events' => 'events#show', as: :issue_events_show
end
