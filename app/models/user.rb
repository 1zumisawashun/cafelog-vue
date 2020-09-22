class User < ApplicationRecord
  mount_uploader :user_image, UserImageUploader

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ratyrate_rater

  has_many :shops, dependent: :destroy
  has_many :pictures
  has_many :images
  has_many :comments
  has_many :likes, dependent: :destroy
  has_many :liked_shop, through: :likes, source: :shop
  def already_liked?(shop)
    self.likes.exists?(shop_id: shop.id)
  end
  
end
