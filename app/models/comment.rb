class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :shop
validates :content, length: {maximum:140}
end
