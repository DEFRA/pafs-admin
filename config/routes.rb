Rails.application.routes.draw do
  namespace :admin do
    resources :users, except: :delete do
      member do
        get :reinvite
      end
    end
    resources :confirmations, only: [:index]
  end
  devise_for :users, controllers: { passwords: "passwords" }

  get "/password/reset" => "reset_password#reset", as: :after_password_reset

  mount PafsCore::Engine, at: "/pc"
  match '(errors)/:status', to: PafsCore::Engine, via: :all, constraints: { status: /\d{3}/ }

  root 'admin/users#index'
end
