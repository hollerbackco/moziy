class Channel::Facebook < Channel
  
  def get_recent(number)
    MiniFB.fql(creator.facebook.token, "SELECT attachment, message, post_id, actor_id FROM stream WHERE filter_key in (SELECT filter_key FROM stream_filter WHERE uid=me() AND type='newsfeed') AND strpos(attachment.href, 'youtube') > 0 AND created_time > 1262196000 LIMIT #{number}") 
  end
  
  def crawl(number)
    recently = get_recent(number)
    
    recently.each do |fbvid|
      vp = VideoProvider.new [fbvid.attachment.href]
      
      vp.get.each do |v_params|
        if v_params.delete(:success)
          unless v = Video.find_by_source_name_and_source_id(v_params[:source_name], v_params[:source_id])
            v = Video.create(v_params.merge({
              :provider_object_id => fbvid.post_id,
              :provider_user_id => fbvid.actor_id
            }))
          end
          self.airings.create :video_id => v.id
        end 
      end
      
    end
  end
  
  def facebook?
    true
  end
  
end