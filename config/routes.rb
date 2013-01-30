Puretv::Application.routes.draw do
  get "attachments/index"

  get "settings/edit"

  get "settings/update"

  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  root :to => "channels#show_root"

  match :terms, to: "pages#terms"
  match :terms, to: "pages#privacy"
  post :invite, to: "invites#create"

  # login
  scope :module => :auth do
    get   :login,   to: "sessions#new"
    post  :login,   to: "sessions#create"
    match :logout,  to: "sessions#destroy"

    get :register,  to: "registrations#new"
    post :register, to: "registrations#create"

    match "oauth/callback" => "oauths#callback"
    match "oauth/:provider" => "oauths#oauth", :as => :auth_at_provider

    resources :password_resets do
      collection do
        match :confirmation
      end
    end
  end

  # channel management
  scope "/me", :module => :manage, :as => :manage do
    get "settings", :to => "settings#edit"
    put "settings", :to => "settings#update"

    resources :likes, :only => [:index, :show]
    resources :channels do
      resources :activities, only: :index
      resources :airings, :only => [:create, :destroy] do
        member do
          put :archive
          put :unarchive, :to => "airings#archive"
        end
      end
      resources :videos do
        collection do
          match :archived
          put :sort
        end
      end
    end

    resources :memberships, :only => [:create, :destroy]
  end

  # channel non-management
  match :explore, :to => "channels#index"

  resources :channels, :only => [:index] do
    member do
      match :chromeless, :to => "channels#show_chromeless"
      match :subscribe
      match :unsubscribe, :to => "channels#subscribe"
    end
    resources :likes, :only => [:create, :destroy]
    resources :videos, :only => [:show] do
      collection do
        get :first
      end
      member do
        get :notes
        get :next
      end
    end
  end

  scope ":name" do
    match :chromeless, :to => "channels#show_chromeless", as: :chromeless
    match "video", :to => "channels#show", as: :start_video
    match ":v", :to => "channels#show"
    match "/", :to => "channels#show", as: :slug
  end
end
