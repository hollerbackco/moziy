class VideosController < ApplicationController
  before_filter :set_channel
  
  def index
    @videos = @channel.videos
  end
  
  def new
    @video = Video.new
  end

  # accepts a list of comma separated links
  def create
    embedly = Embedly::API.new :key => '584b1c340e4811e186fe4040d3dc5c07',
            :user_agent => 'Mozilla/5.0 (compatible; puretv/1.0; jnoh12388@gmail.com)'
    
    if videos = params[:links].split(',').map {|r| r.strip.gsub(/\n/,"")}
    
      objs = embedly.oembed(
                :urls => videos,
                :maxWidth => 450,
                :wmode => 'transparent',
                :method => 'after',
                :autoplay => 'true'
              )
            
      objs.each do |o|
        Video.transaction do
          v = Video.create(:title => o.title, :body => o.html, :description => o.description, :owner_id => current_user.id)
          Airing.create(:video => v, :channel => @channel)
        end
      end
      redirect_to @channel
    else
      render 'new'
    end
  end
  
  def edit
    @video = Video.find(params[:id])
  end
  
  def update
    @video = Video.find(params[:id])
    
    if @video.update_attributes(params[:video])
      redirect_to edit_channel_video_path(@channel, @video)
    else
      render :action => :edit
    end
  end
  
  def destroy
    @video = Video.destroy(params[:id])
    redirect_to edit_channel_path(@channel)
  end

  private
  
    def set_channel
      @channel = Channel.find(params[:channel_id])
    end
    
end
