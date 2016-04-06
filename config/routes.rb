Rails.application.routes.draw do
  devise_for :users

  root 'questions#index'

  resources :questions, except: :index do
    resources :answers, only: [:create, :update, :destroy], shallow: true do
      patch :best, on: :member
    end
  end
end
