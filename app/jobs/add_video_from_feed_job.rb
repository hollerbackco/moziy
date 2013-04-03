class AddVideoFromFeedJob < Struct.new(:entries)
  def perform
    for entry in entries
      channel = Channel.find_by_slug entry[:channel_slug]
      provider_params = video_provider(entry[:url]).get
      provider_params.each do |p|
        create_airing p, channel, entry[:content], entry[:created_at]
      end
    end
  end

  def create_airing(v_params, channel, content, created_at=nil)

    Video.transaction do
      video = create_a_video v_params

      airing = Airing.new(
        :user_id    => channel.creator.id,
        :channel_id => channel.id,
        :video_id   => video.id,
        :content    => content,
        :position   => 0)

      if created_at
        class << airing
          def record_timestamps
            false
          end
        end
        airing.created_at = created_at
        airing.updated_at = created_at
      end

      if airing.save
        Activity.add(:airing_add,
          actor: channel,
          subject: airing
        )
      end

      if created_at
        class << airing
          def record_timestamps
            true
          end
        end
      end
    end
  end

  def create_a_video(v_params)
    Video.where({
      :source_name => v_params[:source_name],
      :source_id => v_params[:source_id]
    }).first_or_create(v_params)
  end

  def video_provider(url)
    @vp ||= VideoProvider.new url
  end
end
