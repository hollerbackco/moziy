class VideosController < ApplicationController
  before_filter :set_channel
  
  def new
    @video = Video.new
  end

  def create
    @video = Video.new(params[:video].merge({:owner_id => current_user.id}))
    
    if @video.save
      Airing.create(:video => @video, :channel => @channel)
      flash[:success] = "Airing created!"
      redirect_to @channel
    else
      render 'new'
    end
  end

  def destroy
    @video = Video.destroy(params[:id])
    redirect_to @channel
  end

  private
  
    def set_channel
      @channel = Channel.find(params[:channel_id])
    end
    
end
