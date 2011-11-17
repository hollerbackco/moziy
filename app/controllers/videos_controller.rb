class VideosController < ApplicationController
  before_filter :set_channel
  
  def index
    @videos = @channel.videos
  end
  
  def new
    @video = Video.new
  end
  
  def show
    video = Video.find(params[:id])
  
    re = {
       :id => video.id,
       :source_name => video.source_name,
       :source_id => video.source_id,
       :title => video.title
      }
      
    render :json => re
  end

  # accepts a list of comma separated links
  def create
    
    
    if (videos = params[:links].split(',').map{|r| r.strip.gsub(/\n/,"")}.select{|r| check_regex r }) && videos.length > 0
      # embedly = Embedly::API.new :key => '584b1c340e4811e186fe4040d3dc5c07',
      #         :user_agent => 'Mozilla/5.0 (compatible; puretv/1.0; jnoh12388@gmail.com)'
      # logger.info videos
      # objs = embedly.oembed(
      #           :urls => videos,
      #           :wmode => 'transparent',
      #           :method => 'after',
      #           :autoplay => 'true'
      #         )
      #       
      # objs.each do |o|
      #   Video.transaction do
      #     v = Video.create(:title => o.title, :body => o.html, :description => o.description, :owner_id => current_user.id)
      #     Airing.create(:video => v, :channel => @channel)
      #   end if o.html
      # end
      
      vp = VideoProvider.new videos
      
      vp.get.each do |v_params|
        Video.transaction do
          v = Video.create(v_params)
          Airing.create :video => v, :channel => @channel
        end if v_params.delete(:success)
      end
        
      redirect_to @channel
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
      redirect_to edit_channel_video_path(@channel, @video)
    else
      render :action => :edit
    end
  end
  
  def destroy
    @video = Video.destroy(params[:id])
    redirect_to channel_videos_path(@channel)
  end
  
  def sort
    order = params[:video]
    Airing.sort(order)
    render :text => true
  end
  
  
  def next
    
    video_ids = @channel.videos.map do |v|
      v.id
    end
    
    current_index = video_ids.index params[:id].to_i
    next_index = (current_index + 1) % @channel.videos.count
    
    video = Video.find(video_ids[next_index])
  
    re = {
       :id => video.id,
       :source_name => video.source_name,
       :source_id => video.source_id,
       :title => video.title
      }
      
    render :json => re
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
