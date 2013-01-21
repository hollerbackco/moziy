# Abstract Provider Class
class VideoProvider

  YOUTUBE_REGEX = /www.youtube.com\/embed\/([a-zA-Z0-9_-]+).*/i
  YOUTUBE2_REGEX = /www.youtube.com\/v\/([a-zA-Z0-9_-]+).*/i
  VIMEO_REGEX   = /player.vimeo.com\/video\/([a-zA-Z0-9_-]+).*/i

  # links is a csv of youtube/vimeo links
  def initialize(links)
    @embedly = Embedly::API.new :key => '584b1c340e4811e186fe4040d3dc5c07',
                  :user_agent => 'Mozilla/5.0 (compatible; puretv/1.0; jnoh12388@gmail.com)'
    @links = split_csv links
  end

  def get
    if @links.any?
      objs = @embedly.oembed(
                :urls => @links,
                :method => 'after',
                :autoplay => 'true')

      objs.map {|o| format_obj o }.compact
    else
      []
    end
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

  def split_csv(links)
    arr = links.split(',').map{|r| r.strip}
    arr.select{|r| check_regex r}
  end

  def check_regex(s)
    embedly_re = Regexp.new(/((http:\/\/(.*youtube\.com\/watch.*|.*\.youtube\.com\/v\/.*|youtu\.be\/.*|.*\.youtube\.com\/user\/.*|.*\.youtube\.com\/.*#.*\/.*|m\.youtube\.com\/watch.*|m\.youtube\.com\/index.*|.*\.youtube\.com\/profile.*|.*\.youtube\.com\/view_play_list.*|.*\.youtube\.com\/playlist.*|www\.vimeo\.com\/groups\/.*\/videos\/.*|www\.vimeo\.com\/.*|vimeo\.com\/groups\/.*\/videos\/.*|vimeo\.com\/.*|vimeo\.com\/m\/#\/.*))|(https:\/\/(.*youtube\.com\/watch.*|.*\.youtube\.com\/v\/.*)))/i)
    s.match(embedly_re)
  end

end
