Rails.application.routes.draw do
  root 'images#index'
  resources :images, only: %i[index show new create]
end
