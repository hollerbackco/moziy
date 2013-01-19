class Video < ActiveRecord::Base
  has_many :airings, :dependent => :destroy
  has_many :likes, through: :airings

  serialize :source_meta, JSON

  validates :title, :presence => true
  validates :body, :presence => true
  validates :source_name, :presence => true, :uniqueness => {:scope => [:source_id]}
  validates :source_id, :presence => true

  mount_uploader :video_image, VideoImageUploader

  def note_count
    airings.count + likes.count
  end

  def gen_random_string
    if random_string.nil?
      chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
      string = ""
      1.upto(10) { |i| string << chars[rand(chars.size-1)] }
      self.random_string = string
    end
    random_string
  end

end
