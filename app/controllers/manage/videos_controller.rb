class Manage::VideosController < Manage::BaseController
  before_filter :set_channel
  before_filter :set_default_title
  before_filter :check_ownership
  before_filter :set_my_channels

  def index
    @videos = @channel.videos
  end

  def archived
    @videos = @channel.archived_videos
  end

  def new
    @video = Video.new
  end

  # accepts a list of comma separated links
  def create
    videos = params[:links].split(',').map{|r| r.strip}.select{|r| check_regex r}

    if videos.any? && videos.length > 0
      vp = VideoProvider.new videos

      vp.get.each {|v_params| create_a_video v_params }

      redirect_to manage_channel_path(@channel)
    else
      redirect_to :back
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

  # def destroy
  #   @video = Video.destroy(params[:id])
  #   redirect_to manage_channel_videos_path(@channel)
  # end

  def sort
    order = params[:video]
    Airing.sort(order)
    render :text => true
  end


  private

  def create_a_video(v_params)
    unless v = Video.find_by_source_name_and_source_id(v_params[:source_name], v_params[:source_id])
      v = Video.create v_params
    end
    @channel.airings.create :video_id => v.id
  end

  def check_ownership
    redirect_to root_path unless current_user.owns?(@channel)
  end

  def set_default_title
    set_title(@channel.title)
  end

  def check_regex(s)
    embedly_re = Regexp.new(/((http:\/\/(.*youtube\.com\/watch.*|.*\.youtube\.com\/v\/.*|youtu\.be\/.*|.*\.youtube\.com\/user\/.*|.*\.youtube\.com\/.*#.*\/.*|m\.youtube\.com\/watch.*|m\.youtube\.com\/index.*|.*\.youtube\.com\/profile.*|.*\.youtube\.com\/view_play_list.*|.*\.youtube\.com\/playlist.*|www\.vimeo\.com\/groups\/.*\/videos\/.*|www\.vimeo\.com\/.*|vimeo\.com\/groups\/.*\/videos\/.*|vimeo\.com\/.*|vimeo\.com\/m\/#\/.*))|(https:\/\/(.*youtube\.com\/watch.*|.*\.youtube\.com\/v\/.*)))/i)
    s.match(embedly_re)
  end

  def set_channel
    @channel = Channel.includes(:airings => :video).find(params[:channel_id])
  end

  def my_channels
    @channels = current_user.channels
  end
end
