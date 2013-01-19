# Abstract Provider Class
class VideoProvider

  YOUTUBE_REGEX = /www.youtube.com\/embed\/([a-zA-Z0-9_-]+).*/i
  YOUTUBE2_REGEX = /www.youtube.com\/v\/([a-zA-Z0-9_-]+).*/i
  VIMEO_REGEX   = /player.vimeo.com\/video\/([a-zA-Z0-9_-]+).*/i

  def initialize(links)
    @embedly = Embedly::API.new :key => '584b1c340e4811e186fe4040d3dc5c07',
                  :user_agent => 'Mozilla/5.0 (compatible; puretv/1.0; jnoh12388@gmail.com)'
    @links = links
  end


  def get
    objs = @embedly.oembed(
              :urls => @links,
              :wmode => 'transparent',
              :method => 'after',
              :autoplay => 'true')

    objs.map {|o| format_obj o }.compact
  end

  private

  def parse_id(html)
    # find the id and source from body (embed code)
    if YOUTUBE_REGEX.match(html)
    elsif YOUTUBE2_REGEX.match(html)
    elsif VIMEO_REGEX.match(html)
    end
    $1
  end

  def format_obj(o)
    if o.html
      {
        :title => o.title,
        :body => o.html,
        :source_name => o.provider_name.downcase,
        :source_id => parse_id(o.html),
        :remote_video_image_url => o.thumbnail_url,
        :description => o.description,
        :source_meta => o,
      }
    else
      nil
    end
  end

end
