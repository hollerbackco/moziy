class Airing < ActiveRecord::Base
  acts_as_nested_set
  
  attr_accessible :video, :channel, :video_id, :channel_id, :parent_id, :state
  
  belongs_to :video #, :counter_cache => true
  belongs_to :channel
  
  validates :video_id, :presence => true
  validates :channel_id, :presence => true, :uniqueness => {:scope => [:video_id]}
  
  
  state_machine :initial => :suggestion do
    
    event :go_live do
      transition all => :live
    end
    
    event :toggle_archive do
      transition :archived => :live
      transition all - :archived => :archived
    end

    state :suggestion
    state :live
    state :archived
  end
    
  def self.sort(ids)
    update_all(
      ["position = STRPOS(?, ','||video_id||',')", ",#{ids.join(',')},"], 
      { :video_id => ids }
    ) 
  end
  
end
