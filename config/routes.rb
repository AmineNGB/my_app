Rails.application.routes.draw do
  # root "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  devise_for :users, controllers: { registrations: "users/registrations" }

  authenticated :user do
    root "pages#home", as: :authenticated_root
  end

  unauthenticated do
    root to: redirect("/users/sign_up")
  end

  namespace :admin do
    resources :groups, only: [ :index, :show ] do
      post :perform_draw, on: :member
    end
  end
  resource :exclusions, only: [ :edit, :update ]

  resources :groups, only: [] do
    member do
      post :join
      post :leave
    end
  end
end
