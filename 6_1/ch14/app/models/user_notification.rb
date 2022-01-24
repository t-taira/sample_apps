class UserNotification < ApplicationRecord
  belongs_to :user

  enum notification_type: %i[login followed]

  validates :message, presence: true

  FOLLOWED_WITHIN_MINUTES = 5.minutes
end
