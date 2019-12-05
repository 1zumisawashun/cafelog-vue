class Picture < ApplicationRecord
  mount_uploader :picture, PictureUploader
  belongs_to :user, optional: true
  belongs_to :shop, optional: true
end
