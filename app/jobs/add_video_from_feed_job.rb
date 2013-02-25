class AddVideoFromFeedJob < Struct.new(:entries)
  def perform
    for entry in entries
      channel = Channel.find_by_slug entry[:channel_slug]
      provider_params = video_provider.get entry[:url]
      provider_params.each {|p| create_airing p, channel, entry[:description] }
    end
  end

  def create_airings(params, channel, user)

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
