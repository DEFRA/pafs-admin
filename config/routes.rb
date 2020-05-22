Rails.application.routes.draw do
  namespace :admin do
    namespace :api do
      post "project/status" => "status_updates#create"
    end

    resource :download, only: [:show, :create]

    resources :failed_submissions, only: :index do
      member do
        put :mark_as_submitted
        put :retry_submission
      end
    end

    resources :user_areas, only: [:destroy]
    resources :users do
      member do
        get :reinvite
      end
    end
    resources :confirmations, only: [:index]
    resources :refresh, only: [:index, :new, :create]
    resources :programme_generation_resets, only: [:index, :new, :create]
    resources :program_uploads, except: [:edit, :update] do
      resources :program_upload_items, only: [:show]
    end
    resources :camc3, only: [:show], controller: :camc3
  end
  devise_for :users, controllers: { passwords: "passwords" }

  get "/password/reset" => "reset_password#reset", as: :after_password_reset

  mount PafsCore::Engine, at: "/pc"
  match '(errors)/:status', to: PafsCore::Engine, via: :all, constraints: { status: /\d{3}/ }

  root 'admin/users#index'
end
