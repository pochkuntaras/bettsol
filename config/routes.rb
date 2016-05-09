Rails.application.routes.draw do
  use_doorkeeper

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

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

  resources :authorizations, only: [:new, :create] do
    get 'confirm/:token', action: :confirm, on: :member, as: :confirm
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end

      resources :questions, only: [:index, :show, :create] do
        resources :answers, only: [:index, :show, :create]
      end
    end
  end
end
