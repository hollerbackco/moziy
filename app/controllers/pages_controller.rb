class PagesController < ApplicationController
  before_filter :require_login, :only => :welcome

  def home
    redirect_to Channel.order("subscriptions_count DESC, updated_at DESC").first
  end

  def terms
  end

  def privacy
  end

  def yc
    if user = User.find_by_username("yc")
      logout
      auto_login(user)
    end

    redirect_to welcome_path
  end

  def welcome
    #best = Channel.best.omit_following current_user

    #if logged_in?
      #explore = Channel.explore_for(current_user).publik.limit(30)
    #end

    @explore = Channel.best

    render :layout => "noheader"
  end
end
