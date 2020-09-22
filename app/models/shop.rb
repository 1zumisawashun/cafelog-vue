class Shop < ApplicationRecord

  def self.search(search) #selfはShop.を意味している
    if search
      Shop.where(['area LIKE ?', "%#{search}%"]).or(Shop.where(['name LIKE ?', "%#{search}%"]))
       #検索とnameの部分一致を表示
    else
      Shop.all
    end
  end
  validates :review, length: {maximum:140}

  acts_as_taggable
  ratyrate_rateable 'review'

  belongs_to :user, optional: true
  has_many :likes
  has_many :liked_users, through: :likes, source: :user
  has_many :images
  has_many :comments

  has_many :pictures, dependent: :destroy #これを付けないとエラーになる。
  accepts_nested_attributes_for :pictures, allow_destroy: true
  #pictures_attributesが自動で生成される

  #has_many :informations
#accepts_nested_attributes_for :informations
 def average_rate
   self.comments.average(:score)
end

end
