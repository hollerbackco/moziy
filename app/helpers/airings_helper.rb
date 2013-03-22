module AiringsHelper
  def mark_as_read(airing)
    airing.mark_as_read! for: current_user

    subscription = @channel.subscription_for(current_user)

    if subscription
      subscription.decrement_unread_count!
      subscription.last_played = airing
      subscription.save
    end
  end

  def airing_json(video)
    obj = {
      id: video.id,
      source_id:   video.source_id,
      source_name: video.source_name,
      title:       video.title,
      channel_id:  video.channel_id,
      channel_slug: video.channel.slug,
      channel:     video.channel,
      note_count:  video.note_count,
      url: start_video_url(video.channel.slug, v: video),
      liked: liked_by_user(video, current_user)
    }
    if video.parent.present?
      obj[:parent] = video.parent.channel.as_json
    end
    obj
  end

  def airing_link(a,txt=nil)
    link_to start_video_path(a.channel.slug, v: a.video.id), class: "permalink" do
      txt.nil? ? yield : txt
    end
  end

  def liked_by_user(airing, user=nil)
    user.present? ? airing.liked_by?(user) : false
  end
end
