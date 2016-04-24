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

  concern :commentable do
    resources :comments, only: :create
  end

  resources :questions, except: :index, concerns: [:votable, :commentable], shallow: true do
    resources :answers, only: [:create, :update, :destroy], concerns: [:votable, :commentable] do
      patch :best, on: :member
    end
  end
end
