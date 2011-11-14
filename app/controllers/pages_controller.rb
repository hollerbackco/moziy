class PagesController < ApplicationController
  
  def home
    redirect_to Channel.order("subscriptions_count DESC").first
  end

end
