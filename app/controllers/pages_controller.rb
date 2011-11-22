class PagesController < ApplicationController
  
  def home
    redirect_to Channel.order("subscriptions_count DESC, updated_at DESC").first
  end
  
  def terms
    
  end

  def privacy
    
  end
end
