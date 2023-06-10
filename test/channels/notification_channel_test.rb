require "test_helper"
require 'sidekiq/testing'

class NotificationChannelTest < ActionCable::Channel::TestCase
  test "subscribes" do
    subscribe
    assert subscription.confirmed?
  end

  test "broadcasts" do
    subscribe
    data = { title: 'title', body: 'body', user_id: users(:one).id, username: users(:one).email }
    Sidekiq::Testing.inline! do
      UserPushNotificationJob.perform_async(data.to_json)
    end
    assert_broadcast_on('notification_global', { title: 'title', body: 'body', from: users(:one).email })
  end
end
