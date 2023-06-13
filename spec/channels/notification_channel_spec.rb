require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe NotificationChannel, type: :channel do
  let(:user) { users(:one) }

  before do
    stub_connection
  end

  context 'subscribes' do
    it 'confirms subscription' do
      subscribe
      expect(subscription).to be_confirmed
    end
  end

  context 'broadcasts' do
    it 'broadcasts on notification_global' do
      subscribe
      data = { title: 'title', body: 'body', user_id: user.id, username: user.email }.to_json
      expect {
        Sidekiq::Testing.inline! do
          UserPushNotificationJob.perform_async(data)
        end
      }.to have_broadcasted_to('notification_global').with(title: 'title', body: 'body', from: user.email)
    end
  end
end