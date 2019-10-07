Rails.application.routes.draw do
  root 'welcome#index'
  resources :images, only: %i[show new create]
end
