require 'test_helper'

class Users::FollowedNotificationJobTest < ActiveJob::TestCase
  setup do
    @user = users(:michael)
  end

  test 'uer_notification is created by job execution' do
    Relationship.delete_all

    Relationship.create!(
      follower_id: users(:archer).id,
      followed_id: @user.id
    )

    count = UserNotification.count
    Users::FollowedNotificationJob.perform_now(@user)
    assert_equal count + 1, UserNotification.count

    user_notification = UserNotification.first
    assert_equal user_notification.notification_type, 'followed'
    assert_equal user_notification.message, 'Sterling Archerさんにフォローされました'
  end

  test 'uer_notification with 3 followers is created by job execution' do
    Relationship.delete_all

    Relationship.create!(
      follower_id: users(:archer).id,
      followed_id: @user.id
    )

    Relationship.create!(
      follower_id: users(:lana).id,
      followed_id: @user.id
    )

    Relationship.create!(
      follower_id: users(:malory).id,
      followed_id: @user.id
    )

    count = UserNotification.count
    Users::FollowedNotificationJob.perform_now(@user)
    assert_equal count + 1, UserNotification.count

    user_notification = UserNotification.first
    assert_equal user_notification.notification_type, 'followed'
    assert_equal user_notification.message, 'Sterling Archerさん他2名にフォローされました'
  end
end
