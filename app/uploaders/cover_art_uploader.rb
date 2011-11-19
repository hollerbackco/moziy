class CoverArtUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def store_dir
   "uploads/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(jpg jpeg png gif)
  end

  def filename
    model.gen_random_string + model.id.to_s + File.extname(@filename) if @filename
  end
  
  def default_url
    "/assets/fallback/" + [version_name, "default.png"].compact.join('_')
  end
   
  process :convert => 'jpg'
  process :resize_to_fill => [512,512]
  
  version :thumb_list do
    process :resize_to_fill => [48,48]
  end
  
  version :thumb_favicon do
    process :resize_to_fill => [16,16]
  end

  version :thumb_player do
    process :resize_to_fill => [175,175]
  end

end