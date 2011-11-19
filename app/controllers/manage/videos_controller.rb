class Manage::VideosController < ApplicationController
  before_filter :set_channel
  
  def index
    @videos = @channel.videos
  end
  
  def new
    @video = Video.new
  end


  # accepts a list of comma separated links
  def create
    
    if (videos = params[:links].split(',').map{|r| r.strip.gsub(/\n/,"")}.select{|r| check_regex r }) && videos.length > 0
      
      vp = VideoProvider.new videos
      
      vp.get.each do |v_params|
        Video.transaction do
          v = Video.create(v_params)
          Airing.create :video => v, :channel => @channel
        end if v_params.delete(:success)
      end
        
      redirect_to manage_channel_path(@channel)
    else
      
      @video = Video.new
      render 'new'
    end
  end
  
  def edit
    @video = Video.find(params[:id])
  end
  
  def update
    @video = Video.find(params[:id])
    
    if @video.update_attributes(params[:video])
      redirect_to edit_manage_channel_video_path(@channel, @video)
    else
      render :action => :edit
    end
  end
  
  def destroy
    @video = Video.destroy(params[:id])
    redirect_to manage_channel_videos_path(@channel)
  end
  
  def sort
    order = params[:video]
    Airing.sort(order)
    render :text => true
  end
  
  
  private
  
    def check_regex(s)
      embedly_re = Regexp.new(/((http:\/\/(.*youtube\.com\/watch.*|.*\.youtube\.com\/v\/.*|youtu\.be\/.*|.*\.youtube\.com\/user\/.*|.*\.youtube\.com\/.*#.*\/.*|m\.youtube\.com\/watch.*|m\.youtube\.com\/index.*|.*\.youtube\.com\/profile.*|.*\.youtube\.com\/view_play_list.*|.*\.youtube\.com\/playlist.*|www\.vimeo\.com\/groups\/.*\/videos\/.*|www\.vimeo\.com\/.*|vimeo\.com\/groups\/.*\/videos\/.*|vimeo\.com\/.*|vimeo\.com\/m\/#\/.*))|(https:\/\/(.*youtube\.com\/watch.*|.*\.youtube\.com\/v\/.*)))/i)
      s.match(embedly_re)
    end
    
    def set_channel
      @channel = Channel.includes(:airings => :video).find(params[:channel_id])
    end
end
