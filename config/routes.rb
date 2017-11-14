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
  resources :booking_requests,    except: %i(index show edit)
  resources :users,               only: %i(show update)
  resources :sessions,            only: :new
  resources :password_resets,     except: %i(destroy show index)
  resources :tours,               only: %i(index show)
  resources :categories,          only: :show

  resources :reviews, only: %i(create update destroy) do
    member do
      post :like
      delete :unlike
    end
    resources :comments, only: %i(new create), module: :reviews
  end

  resources :comments, only: [] do
    resources :comments, only: %i(new create), module: :comments
  end

  namespace :admin do
    root "main#index"
    resources :users, except: %i(create destroy new)
    resources :tours do
      resources :trips, only: %i(new create)
    end
    resources :trips, only: %i(show edit update destroy)
    resources :categories
    resources :booking_requests, except: :show
    resources :reviews, only: %i(show destroy)
  end

  mount Ckeditor::Engine => "/ckeditor"
end
