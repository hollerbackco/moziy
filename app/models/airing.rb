class Airing < ActiveRecord::Base
  belongs_to :video #, :counter_cache => true
  belongs_to :channel
  
  validates :channel_id, :presence => true, :uniqueness => {:scope => [:video_id]}
  
  def self.sort(ids)
    update_all(
      ["position = STRPOS(?, ','||video_id||',')", ",#{ids.join(',')},"], 
      { :video_id => ids }
    ) 
  end
  
end
