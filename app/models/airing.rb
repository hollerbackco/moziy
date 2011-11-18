class Airing < ActiveRecord::Base
  belongs_to :video #, :counter_cache => true
  belongs_to :channel
  
  validates :video_id, :presence => true
  validates :channel_id, :presence => true, :uniqueness => {:scope => [:video_id]}
  
  state_machine :initial => :suggestion do
    
      after_transition any => :suggestion do |transition|
        self.seatbelt = 'off' # self is the record
      end
      
      
      event :go_live do
        transition :any => :live
      end
      
      event :archive do
        transition :any => :archive
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
