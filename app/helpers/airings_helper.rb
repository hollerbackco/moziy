module AiringsHelper
  def airing_link(a,txt=nil)
    link_to start_video_path(a.channel.slug, v: a.video.id), class: "permalink" do
      txt.nil? ? yield : txt
    end
  end
end
