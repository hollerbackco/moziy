Puretv::Application.routes.draw do

  root :to => "pages#home"
  
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
    resources :videos do
      collection do
        put :sort
      end
    end
    resources :memberships, :only => [:create, :destroy]
  end
  
  
  
end
