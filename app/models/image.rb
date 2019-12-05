class Image < ApplicationRecord

   mount_uploader :image, ImageUploader

   belongs_to :user, optional: true
   belongs_to :shop, optional: true


end
