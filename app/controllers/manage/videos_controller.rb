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

  # accepts a list of comma separated links
  def create
    vp = VideoProvider.new params[:links]
    video_params = vp.get

    airings = video_params.each do |v_params|
      v = create_a_video v_params
      airing_json @channel.airings.create(:video_id => v.id)
    end

    respond_to do |format|
      format.html { redirect_to manage_channel_path(@channel) }
      format.json { render json: {airings: airings} }
    end
  end

  def edit
    @airing = @channel.airings.find(params[:id])
    set_title @airing.title
  end

  def update
    @airing = @channel.airings.find(params[:id])

    if @airing.video.update_attributes(params[:video])
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

  def airing_json(video)
    obj = {
     :id => video.id,
     :source_name => video.source_name,
     :source_id => video.source_id,
     :title => video.title,
     :channel_id => video.channel_id,
     :channel => video.channel,
     :note_count => video.note_count
    }
    if video.parent.present?
      obj[:parent] = video.parent.channel.as_json
    end
    obj
  end

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
