Rails.application.routes.draw do
  namespace :admin do
    resources :users
  end
  devise_for :users, controllers: { passwords: "passwords" }

  get "/password/reset" => "reset_password#reset", as: :after_password_reset

  mount PafsCore::Engine, at: "/pc"

  root 'admin/users#index'
end
