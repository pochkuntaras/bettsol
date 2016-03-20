Rails.application.routes.draw do
  resources :questions, except: [:update, :destroy]
end
