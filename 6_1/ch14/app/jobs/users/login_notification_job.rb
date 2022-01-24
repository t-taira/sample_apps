class Users::LoginNotificationJob < ApplicationJob
  queue_as :default

  def perform(user)
    return if exists_login_user_notification?

    UserNotification.create!(
      user: user,
      notification_type: :login,
      message: '初回ログインありがとうございます。'
    )
  end

  private

  def exists_login_user_notification?
    UserNotification.where(user: @user, notification_type: :login).exists?
  end
end
