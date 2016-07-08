Rails.application.routes.draw do
  root 'welcome#index'
  get '/date', to: 'welcome#get_data'
  get '/autocomplete_street', to: 'welcome#autocomplete_street'
end
