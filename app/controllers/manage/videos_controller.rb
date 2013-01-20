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
    vp = VideoProvider.new params[:links]
    video_params = vp.get

    video_params.each do |v_params|
      v = create_a_video v_params
      @channel.airings.create :video_id => v.id
    end

    redirect_to manage_channel_path(@channel)
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
    video = Video.find_by_source_name_and_source_id(v_params[:source_name], v_params[:source_id])
    if !video
      video = Video.create v_params
    end
    video
  end

  def check_ownership
    redirect_to root_path unless current_user.owns?(@channel)
  end

  def set_default_title
    set_title(@channel.title)
  end

  def set_channel
    @channel = Channel.includes(:airings => :video).find(params[:channel_id])
  end

  def my_channels
    @channels = current_user.channels
  end
end
