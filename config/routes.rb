Puretv::Application.routes.draw do

  root :to => "channels#index"
    
  match :terms, :to => "pages#terms"
  match :terms, :to => "pages#privacy"
  
  
  # login
  scope :module => :auth do
    get   :login,   :to => "sessions#new"
    post  :login,   :to => "sessions#create"
    match :logout,  :to => "sessions#destroy"
    
    get :register,  :to => "registrations#new"
    post :register, :to => "registrations#create"
    
    match "oauth/callback" => "oauths#callback"
    match "oauth/:provider" => "oauths#oauth", :as => :auth_at_provider
    
    resources :password_resets do
      collection do
        match :confirmation
      end
    end
  end
  
  # channel management
  scope "/manage", :module => :manage, :as => :manage do
    resources :channels do
      resources :airings, :only => [:create, :destroy]
      resources :videos do 
        collection do
          put :sort
        end
      end
    end
    
    resources :memberships, :only => [:create, :destroy]
  end
  
  # channel non-management
  match :explore, :to => "channels#index"
  resources :channels, :only => [:index, :show] do
    member do 
      match :chromeless, :to => "channels#show_chromeless"
      match :subscribe
      match :unsubscribe, :to => "channels#subscribe"
    end
    resources :videos, :only => [:show] do
      member do
        get :next
      end
    end
  end

end
