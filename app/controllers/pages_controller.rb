class PagesController < ApplicationController
  
  def home
    redirect_to Channel.order("subscriptions_count DESC, updated_at DESC").first
  end
  
  def about
    
  end

end
