module ChannelsHelper
  def top_channel
    @top ||= Channel.order("subscriptions_count DESC, updated_at DESC").first
  end

  def is_top?(channel)
    top_channel.id == channel.id
  end
end
