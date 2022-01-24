class Users::FollowedNotificationJob < ApplicationJob
  queue_as :default

  def perform(user)
    followers = Relationship.recent_followers(user.id, UserNotification::FOLLOWED_WITHIN_MINUTES)
    return if followers.size.zero?

    UserNotification.create!(
      user: user,
      notification_type: :followed,
      message: create_massage(followers)
    )
  end

  private

  def create_massage(followers)
    return "#{followers.pop.name}さんにフォローされました" if followers.size == 1
    return "#{followers.pop.name}さん他#{followers.size}名にフォローされました" if followers.size > 1
  end
end
