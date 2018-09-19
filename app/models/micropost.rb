class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader

  scope :order_desc, ->{order created_at: "desc"}

  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.micropost.content.max_length}
  validate :picture_size

  private

  def picture_size
    if picture.size > Settings.micropost.picture.max_size.megabytes
      errors.add(:picture, t("flash.picture_error"))
    end
  end
end
