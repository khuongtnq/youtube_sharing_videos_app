class NotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'notification_global'
  end
end
