# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  namespace :admin do
    namespace :api do
      post "project/status" => "status_updates#create"
    end

    resource :download, only: %i[show create]
    resource :download_all_users, only: [:show]

    resources :failed_submissions, only: :index do
      member do
        put :mark_as_submitted
        put :retry_submission
      end
    end

    resources :projects do
      member do
        get :edit
        patch :save
      end
    end

    resources :user_areas, only: [:destroy]
    resources :users do
      member do
        get :reinvite
      end
    end
    resources :confirmations, only: [:index]
    resources :camc3, only: [:show], controller: :camc3
    resources :organisations, only: %i[index edit update]
  end
  devise_for :users, controllers: { passwords: "passwords" }

  get "/password/reset" => "reset_password#reset", as: :after_password_reset

  mount PafsCore::Engine, at: "/pc"

  match "(errors)/:status", to: PafsCore::Engine, via: :all, constraints: { status: /\d{3}/ }

  root "admin/users#index"
end
# rubocop:enable Metrics/BlockLength
