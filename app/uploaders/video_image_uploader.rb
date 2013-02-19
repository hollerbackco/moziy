# encoding: utf-8
class VideoImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :fog

  def store_dir
    "uploads/#{mounted_as}/#{model.id}"
  end

  def filename
    model.gen_random_string + File.extname(@filename) if @filename
  end

  def extension_white_list
    %w(jpg jpeg png gif)
  end

  def default_url
    "/assets/fallback/" + [version_name, "default.jpg"].compact.join('_')
  end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  version :thumb_list do
    process :resize_to_fill => [100,100]
  end

  version :large do
    process :resize_to_fill => [300,200]
  end
end
