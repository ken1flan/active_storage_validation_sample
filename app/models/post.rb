class Post < ApplicationRecord
  has_one_attached :main_image
  has_many_attached :other_images

  validates :title, presence: true, length: { maximum: 64 }
  validates :description, presence: true, length: { maximum: 4096 }
end
