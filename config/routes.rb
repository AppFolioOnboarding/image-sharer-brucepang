Rails.application.routes.draw do
  root 'images#index'
  resources :images, only: %i[index show new create destroy]
  resources :feedbacks, only: [:new]

  namespace :api do
    resource :feedbacks, only: [:create]
  end
end
