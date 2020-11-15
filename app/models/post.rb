class Post < ApplicationRecord
  has_one_attached :image

  validates :title, presence: true, length: { maximum: 64 }
  validates :description, presence: true, length: { maximum: 4096 }
end
