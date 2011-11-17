# Abstract Provider Class
class VideoProvider
  
  Youtube1_re = /www.youtube.com\/embed\/([a-zA-Z0-9_-]+).*/i
  Youtube2_re = /www.youtube.com\/v\/([a-zA-Z0-9_-]+).*/i
  Vimeo_re = /player.vimeo.com\/video\/([a-zA-Z0-9_-]+).*/i
  
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
              :autoplay => 'true'
            )
            
    objs.map do |o|
      if o.html
        {
          :success => true,
          :title => o.title,
          :body => o.html,
          :source_name => o.provider_name.downcase,
          :source_id => parse_id(o.html),
          :description => o.description
        }
      else
        {:success => false}
      end
    end
  end
  
  private
  
    def parse_id(html)
      # find the id and source from body (embed code)
      if Youtube1_re.match(html)
      elsif Youtube2_re.match(html)
      elsif Vimeo_re.match(html)
      end
      $1
    end

end
  