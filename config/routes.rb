Rails.application.routes.draw do
  root "static_pages#home"

  get     "/about",   to: "static_pages#about"
  get     "/contact", to: "static_pages#contact"
  get     "/signup",  to: "users#new"
  post    "/signup",  to: "users#create"
  get     "/login",   to: "sessions#new"
  post    "/login",   to: "sessions#create"
  delete  "/logout",  to: "sessions#destroy"

  resources :account_activations, only: :edit
  resources :users,               only: %i(show update)
  resources :sessions,            only: :new
  resources :password_resets,     except: %i(destroy show index)

  namespace :admin do
    root "main#index"
    resources :users, except: %i(create destroy new)
    resources :tours
    resources :categories
  end

  mount Ckeditor::Engine => "/ckeditor"
end
