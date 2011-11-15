Puretv::Application.routes.draw do
  
  root :to => "channels#index"
  
  match :explore, :to => "channels#index"
  
  # login
  scope :module => :auth do
    get   :login,   :to => "sessions#new"
    post  :login,   :to => "sessions#create"
    match :logout,  :to => "sessions#destroy"
    
    get :register,  :to => "registrations#new"
    post :register, :to => "registrations#create"
    
    resources :password_resets do
      collection do
        match :confirmation
      end
    end
    
  end
  
  
  
  resources :channels do
    member do 
      match :subscribe
      match :unsubscribe, :to => "channels#subscribe"
    end
    resources :videos do
      collection do
        put :sort
      end
    end
    resources :subscriptions, :only => [:create, :destroy]
    resources :memberships, :only => [:create, :destroy]
  end
  
  
  
end
