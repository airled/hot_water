Rails.application.routes.draw do
  root 'welcome#index'
  get '/date', to: 'welcome#get_data'
end
