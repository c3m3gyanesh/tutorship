# frozen_string_literal: true

Rails.application.routes.draw do
  scope format: false do
    # Github login
    devise_for :users, path: '/', controllers: {
      omniauth_callbacks: 'sessions'
    }

    # Sign in, Sign up & Profile
    devise_scope :user do
      get '@:login', to: 'users#show', as: 'profile'
      delete '@:login', to: 'users#destroy'

      get 'login', to: redirect('/auth/github'), as: 'login'
      get 'logout', to: 'sessions#logout', as: 'logout'
    end

    # Pages
    root 'pages#index'
  end
end
