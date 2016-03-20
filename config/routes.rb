Rails.application.routes.draw do
  resources :questions, except: [:update, :destroy] do
    resources :answers, only: [:new, :create]
  end
end
