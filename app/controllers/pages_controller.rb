class PagesController < ApplicationController
  before_filter :require_login, :only => :welcome

  def home
    redirect_to Channel.order("subscriptions_count DESC, updated_at DESC").first
  end

  def terms
  end

  def privacy
  end

  def welcome
    @explore = Channel.publik.explore.limit(20)
    render :layout => "noheader"
  end
end
