Rails.application.routes.draw do
  devise_for :users

  root 'questions#index'

  concern :votable do
    member do
      patch :like
      patch :dislike
      delete :indifferent
    end
  end

  resources :questions, except: :index, concerns: :votable do
    resources :answers, only: [:create, :update, :destroy], concerns: :votable, shallow: true do
      patch :best, on: :member
    end
  end
end
