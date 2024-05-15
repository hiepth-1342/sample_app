class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: Settings.micropost.resize_limit_500_500
  end
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.micropost.max_len_content}
  scope :newest, ->{order(created_at: :desc)}
  validates :image, content_type: {in: Settings.micropost.img_type,
                    message: I18n.t("validate.valid_img_format")},
                    size:         { less_than: Settings.micropost.max_size_5.megabytes,
                    message:  I18n.t("validate.less_than_mb", size: Settings.micropost.max_size_5) }
end
