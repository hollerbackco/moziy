class AddVideoJob < Struct.new(:urls,:channel_id,:add_video_request_id,:user_id)
  def perform
    @video_params = video_provider.get
    @video_request = AddVideoRequest.find(add_video_request_id)
    @channel = Channel.find channel_id
    @user = User.find(user_id)

    airings = create_airings

    if airings.any?
      @video_request.msg = airings.map(&:title).join(", ")
      @video_request.save
      @video_request.complete
    else
      @video_request.msg = "videos could not be added"
      @video_request.save
      @video_request.errored
    end
  end

  def create_airings
    airings = @video_params.map do |v_params|
      Video.transaction do
        video = create_a_video v_params

        @airing = Airing.create(
          :user_id => @user.id,
          :channel_id => @channel.id,
          :video_id => video.id,
          :position => 0)

        if @airing.valid?
          Activity.add(:airing_add,
            actor: @channel,
            subject: @airing
          )
        end
      end

      @airing
    end
    airings
  end

  def create_a_video(v_params)
    Video.where({
      :source_name => v_params[:source_name],
      :source_id => v_params[:source_id]
    }).first_or_create(v_params)
  end

  def video_provider
    @vp ||= VideoProvider.new urls
  end
end
