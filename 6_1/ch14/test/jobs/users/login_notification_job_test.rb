require 'test_helper'

class Users::LoginNotificationJobTest < ActiveJob::TestCase
  setup do
    @user = users(:michael)
  end

  test 'uer_notification is created by job execution' do
    count = UserNotification.count
    Users::LoginNotificationJob.perform_now(@user)
    assert_equal count + 1, UserNotification.count

    user_notification = UserNotification.first
    assert_equal user_notification.notification_type, 'login'
    assert_equal user_notification.message, '初回ログインありがとうございます。'
  end
end
