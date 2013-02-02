class AddVideoJob < Struct.new(:urls,:channel_id,:add_video_request_id)
  def perform
    @video_params = video_provider.get
    @video_request = AddVideoRequest.find(add_video_request_id)
    airings = create_airings

    if airings.any?
      @video_request.msg = airings.map(&:title).join(", ")
      @video_request.save
      @video_request.complete
    else
      @video_request.msg = "videos could not be added"
      @video_request.save
      @video_request.error
    end
  end

  def create_airings
    airings = @video_params.map do |v_params|
      Video.transaction do
        video = create_a_video v_params

        @airing = Airing.create(
          :channel_id => channel_id,
          :video_id => video.id,
          :position => 0)

        if @airing.valid?
          Activity.add(:airing_add, actor_id: channel_id,
            actor_type: "Channel",
            subject: @airing
          )
        end
      end

      @airing
    end
    airings
  end

  def create_a_video(v_params)
    video = Video.find_by_source_name_and_source_id(v_params[:source_name], v_params[:source_id])
    if !video
      video = Video.create v_params
    end
    video
  end

  def video_provider
    @vp ||= VideoProvider.new urls
  end
end
