class PhotoUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  version :standard do
    process resize_to_fill: [150, 150]
  end
  
  version :thumbnail do
    process resize_to_fill: [50, 50]
  end 
end