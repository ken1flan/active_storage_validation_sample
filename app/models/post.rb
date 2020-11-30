class Post < ApplicationRecord
  has_one_attached :main_image
  has_many_attached :other_images

  validates :title, presence: true, length: { maximum: 64 }
  validates :description, presence: true, length: { maximum: 4096 }
  validates :main_image,
    attached_file_presence: true,
    attached_file_size: { maximum: 5.megabytes },
    attached_file_type: { pattern: /^image\// }
  validates :other_images,
    attached_file_presence: true,
    attached_file_number: { maximum: 3 },
    attached_file_size: { maximum: 5.megabytes },
    attached_file_type: { pattern: /^image\// }
end
